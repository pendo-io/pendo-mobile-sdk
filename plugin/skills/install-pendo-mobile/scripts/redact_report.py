#!/usr/bin/env python3
"""Mask secrets in a Pendo support report before it is shown or saved."""
import argparse
import collections
import re
import sys
from typing import NamedTuple

EXIT_SECRETS_FOUND = 1
PLACEHOLDERS = frozenset({"YOUR_API_KEY_HERE", "YOUR_SCHEME_ID_HERE"})
LITERAL_KIND = "literal"
SECRET_KIND = "secret"

PENDO_CALLS = ("setup", "Setup", "startSession", "StartSession", "initSDK", "initSdk", "InitSDK", "setVisitorId",
               "setAccountId", "setVisitorData", "setAccountData", "switchVisitor", "SwitchVisitor")
CALL_START = re.compile(rf"\b(?:{'|'.join(PENDO_CALLS)})\s*\(")
MESSAGE_START = re.compile(rf"(?<=[\w\])] )(?:{'|'.join(PENDO_CALLS)}|initWithSessionInfo)\w*:")
CALL_FORMS = ((CALL_START, "(", ")"), (MESSAGE_START, "[", "]"))
TRIPLE_QUOTES = ('"""', "'''")
CODE_QUOTES = "\"'`"
BACKTICK = "`"
FENCE_LINE = re.compile(r"^[ \t]*```", re.M)
BLANK_LINE = re.compile(r"\n[ \t]*\n")
MAP_KEY_BEFORE = re.compile(r"[{\[(,]\s*@?$")
MAP_KEY_AFTER = re.compile(r"\s*(?::|to\b)")

QUOTED = r""""(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*'"""
QUOTED_LITERAL = re.compile(QUOTED)
LITERAL_CHAIN = re.compile(rf"(?:{QUOTED})(?:\s*\+\s*(?:{QUOTED}))+")

SECRET_NAME = r"[A-Za-z0-9_]*?(?:(?:api|app)[_-]?key|secret|token|password|passwd)"
KEY_VALUE = re.compile(rf"""(?i)\b({SECRET_NAME})(["']?\s*[:=]\s*)(["']?)([^\s"',;)}}<]{{4,}})\3""")
IDENTITY_ASSIGNMENT = re.compile(r"""(?i)\b((?:visitor|account)[_-]?id\s*[:=]\s*@?)(["'])((?:\\.|(?!\2)[^\n])*)\2""")
HOME_FOLDER = re.compile(r"(/Users/|/home/|[A-Za-z]:\\Users\\)([^/\\\s\"'`<>]+)")
USER_KIND = "user"
DOTTED_REFERENCE = re.compile(r"[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)+")
XML_SECRET_RULES = (
    re.compile(r"(?is)(<key>[^<]*(?:key|secret|token|password)[^<]*</key>\s*<string>)([^<]+)(</string>)"),
    re.compile(r'(?is)(<string\s+name="[^"]*(?:key|secret|token|password)[^"]*"\s*>)([^<]+)(</string>)'),
)
CODE_IDENTIFIER = re.compile(r"(?:[A-Z]?[a-z]{2,}|\d+)+")

PATTERN_RULES = (
    ("bearer", re.compile(r"(?i)\bbearer\s+[A-Za-z0-9._~+/=-]{8,}")),
    ("jwt", re.compile(r"(?:\b[A-Za-z0-9_-]+\.)?\beyJ[A-Za-z0-9_-]{4,}(?:\.[A-Za-z0-9_-]+){0,2}")),
    ("email", re.compile(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b")),
    ("hex", re.compile(r"\b[0-9a-fA-F]{32,}\b")),
    ("base64", re.compile(r"(?=[A-Za-z0-9+_-]*\d)(?=[A-Za-z0-9+_-]*[a-z])(?=[A-Za-z0-9+_-]*[A-Z])"
                          r"[A-Za-z0-9+_-]{24,}={0,2}")),
)


class Literal(NamedTuple):
    content_start: int
    content_end: int


def mask(kind):
    return f"<redacted:{kind}>"


def is_mask_or_placeholder(value):
    return value in PLACEHOLDERS or value.startswith("<redacted:") or value == ""


def is_inside_code_span(text, index):
    line_start = text.rfind("\n", 0, index) + 1
    return text.count(BACKTICK, line_start, index) % 2 == 1


def literal_close(text, start, quote, limit):
    """Index where the literal opened by quote ends, and whether its closing quote was found."""
    index = start
    while index < limit:
        if text[index] == "\\":
            index += 2
        elif text.startswith(quote, index):
            return index, True
        elif text[index] == "\n" and quote in "\"'":
            return index, False
        else:
            index += 1
    return limit, False


def opening_quote(text, index, quotes):
    triple = next((quote for quote in TRIPLE_QUOTES if text.startswith(quote, index)), None)
    return triple or (text[index] if text[index] in quotes else None)


def scan_call(text, start, in_code_span, opener, closer):
    """Where the call's arguments end, the literals inside them, and whether that end is certain."""
    fence = FENCE_LINE.search(text, start)
    limit = fence.start() if fence else len(text)
    quotes = CODE_QUOTES.replace(BACKTICK, "") if in_code_span else CODE_QUOTES
    literals, depth, index = [], 1, start
    while index < limit:
        char = text[index]
        if in_code_span and char == BACKTICK:
            return index, literals, True
        quote = opening_quote(text, index, quotes)
        if quote:
            close, closed = literal_close(text, index + len(quote), quote, limit)
            literals.append(Literal(index + len(quote), close))
            index = close + len(quote) if closed else close
            continue
        if char == opener:
            depth += 1
        elif char == closer:
            depth -= 1
            if depth == 0:
                return index, literals, True
        index += 1
    return limit, literals, False


def call_region(text, start, opener, closer):
    end, literals, certain = scan_call(text, start, is_inside_code_span(text, start), opener, closer)
    if not certain:
        blank = BLANK_LINE.search(text, start)
        end = min(end, blank.start()) if blank else end
    return end, [Literal(lit.content_start, min(lit.content_end, end)) for lit in literals if lit.content_start <= end]


def is_map_key(text, arguments_start, literal):
    before = text[arguments_start:literal.content_start - 1]
    return bool(MAP_KEY_BEFORE.search(before) and MAP_KEY_AFTER.match(text, literal.content_end + 1))


def mask_call_literals(text, counts, call_start, opener, closer):
    pieces, cursor = [], 0
    for call in call_start.finditer(text):
        if call.start() < cursor:
            continue
        end, literals = call_region(text, call.end(), opener, closer)
        position = call.end()
        pieces.append(text[cursor:position])
        for literal in literals:
            value = text[literal.content_start:literal.content_end]
            if is_mask_or_placeholder(value) or is_map_key(text, call.end(), literal):
                continue
            pieces += [text[position:literal.content_start], mask(LITERAL_KIND)]
            position = literal.content_end
            counts[LITERAL_KIND] += 1
        pieces.append(text[position:end])
        cursor = end
    pieces.append(text[cursor:])
    return "".join(pieces)


def mask_identity_assignments(text, counts):
    def replace(found):
        if is_mask_or_placeholder(found.group(3)):
            return found.group(0)
        counts[LITERAL_KIND] += 1
        return f"{found.group(1)}{found.group(2)}{mask(LITERAL_KIND)}{found.group(2)}"

    return IDENTITY_ASSIGNMENT.sub(replace, text)


def mask_home_folders(text, counts):
    def replace(found):
        counts[USER_KIND] += 1
        return f"{found.group(1)}{mask(USER_KIND)}"

    return HOME_FOLDER.sub(lambda found: found.group(0) if found.group(2).startswith("<redacted:") else replace(found), text)


def secret_kind(value):
    return next((kind for kind, pattern in PATTERN_RULES if pattern.search(value)), None)


def mask_split_literals(text, counts):
    def replace_chain(chain):
        parts = list(QUOTED_LITERAL.finditer(chain.group(0)))
        kind = secret_kind("".join(part.group(0)[1:-1] for part in parts))
        if kind is None:
            return chain.group(0)
        counts[kind] += 1
        return QUOTED_LITERAL.sub(lambda part: f"{part.group(0)[0]}{mask(kind)}{part.group(0)[0]}", chain.group(0))

    return LITERAL_CHAIN.sub(replace_chain, text)


def mask_named_secrets(text, counts):
    def replace_key_value(found):
        quote, value = found.group(3), found.group(4)
        if is_mask_or_placeholder(value) or (not quote and DOTTED_REFERENCE.fullmatch(value)):
            return found.group(0)
        counts[SECRET_KIND] += 1
        return f"{found.group(1)}{found.group(2)}{quote}{mask(SECRET_KIND)}{quote}"

    def replace_xml(found):
        if is_mask_or_placeholder(found.group(2).strip()):
            return found.group(0)
        counts[SECRET_KIND] += 1
        return f"{found.group(1)}{mask(SECRET_KIND)}{found.group(3)}"

    text = KEY_VALUE.sub(replace_key_value, text)
    for rule in XML_SECRET_RULES:
        text = rule.sub(replace_xml, text)
    return text


def mask_secret_shapes(text, counts):
    for kind, pattern in PATTERN_RULES:
        def replace(found, kind=kind):
            value = found.group(0)
            if is_mask_or_placeholder(value) or (kind == "base64" and CODE_IDENTIFIER.fullmatch(value)):
                return value
            counts[kind] += 1
            return mask(kind)

        text = pattern.sub(replace, text)
    return text


def redact(text):
    counts = collections.Counter()
    for call_start, opener, closer in CALL_FORMS:
        text = mask_call_literals(text, counts, call_start, opener, closer)
    text = mask_identity_assignments(text, counts)
    text = mask_home_folders(text, counts)
    text = mask_split_literals(text, counts)
    text = mask_named_secrets(text, counts)
    text = mask_secret_shapes(text, counts)
    return text, counts


def summary(counts):
    if not counts:
        return "redacted 0 values"
    details = ", ".join(f"{kind}={count}" for kind, count in sorted(counts.items()))
    return f"redacted {sum(counts.values())} value(s): {details}"


def main(argv=None, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="exit 1 if anything would be masked")
    args = parser.parse_args(argv)
    redacted, counts = redact(stdin.read())
    if args.check:
        return EXIT_SECRETS_FOUND if counts else 0
    stdout.write(redacted)
    print(summary(counts), file=stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
