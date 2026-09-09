# Visitor & Account Identity — Resolution Reference

Consulted by every platform reference file (`ios.md`, `android.md`, `react-native.md`, `expo.md`, `flutter.md`, `maui.md`) for one job only: **finding an identifier that is both real and safe to send, and choosing where to place the `startSession` call.** It does not cover `setup()` placement — `setup()` is call-once-only on every platform, always goes at that platform's standard app-init point (defined per-platform in each reference file), and its placement is unaffected by anything in this file.

## 0. The hard rules

Two rules govern every value this file leads you to. Violating either produces an install that **compiles, runs, and reports success** while being wrong — so neither is caught by the build, the diff, or anything downstream, and both depend entirely on the care taken here.

### Rule 1 — never emit a fabricated identifier

An install that calls `startSession("user123", ...)` produces garbage analytics forever, because the code path is indistinguishable from a correct install. **Never emit a placeholder visitor ID, account ID, or any other identifier.** Not `"user123"`, not `"YOUR_VISITOR_ID"`, not a value invented to make the install "complete."

**This rule governs identifiers, and the API key and URL scheme are not identifiers.** Those two are configuration, resolved by `SKILL.md` Phase 5, which may legitimately write a declared placeholder when the user does not have them yet. That is not an exception to Rule 1 and does not create one: a placeholder *credential* means the SDK reports to nothing, so no data flows and nothing is polluted, and one string edit fixes it. A placeholder *identifier* means fabricated visitors flow into the customer's subscription, indistinguishable from real ones, and cannot be un-sent. Never reason from the existence of Phase 5's fallback to a `startSession` placeholder.

### Rule 2 — never pass a credential or a secret as an identifier

`visitorId`, `accountId`, and the visitor/account data maps are transmitted to Pendo's analytics backend and stored there. A value that **authenticates** the user — one that would let whoever holds it act as that user — must never be any of them. Never use:

> an auth / bearer / access / refresh / ID token · an API key or client secret · a password or password hash · a PIN or passcode · a seed, recovery, or mnemonic phrase · a private key · a session cookie or session ID · an OAuth authorization code

Rule 1 produces bad analytics. Rule 2 exfiltrates a credential into a third-party system, and on a wallet, health, or banking app that is a security incident rather than a data-quality problem. It is the more dangerous of the two precisely because the value *is* real, stable, and unique — every property that makes an identifier look good.

**What Rule 2 does not ban.** An email address, a username, an internal/database user ID, a customer, tenant, or organization ID — these are exactly what Pendo expects as `visitorId`/`accountId`, and identifying real users is the entire point of the install. Rule 2 is about credentials and secrets, **not** about personal data in general. Never reject a real identifier merely because it identifies a real person.

**The test, when a value sits near the line:** *does presenting this value to the app's own backend get you in as that user?* If yes, it is a credential — excluded, however convenient, stable, or unique it is. A random UUID kept in secure storage purely to label an install is not a credential (§1's anonymous allowance); that same UUID **is** one if the backend accepts it as proof of identity.

**Do not sanitize a credential into an identifier.** Do not hash it, truncate it, or take a prefix. A low-entropy secret (a 4-digit PIN) is trivially recovered from its hash, and a derived value still lets a future leak be correlated back to the secret. There is no transformation that makes a credential an acceptable `visitorId`.

### The shared fallback: when there is no usable identifier

**This is the outcome for both rules** — when no real identifier can be found, *and* when the only identity-shaped values in the app turn out to be credentials Rule 2 excludes. The two cases are indistinguishable in their result: emit the `setup()` call only. Do not write a `startSession` call at all — not with placeholder arguments, not commented out as a "TODO" call with fake values. Leave it unwired, and report exactly what's missing under "Requires your attention" (see §5).

A credential-only app is therefore **not** an install failure and not a reason to stop the run. It is the no-identifier case, reached by a different route, and §5's report must say which route: name the *kind* of value you rejected ("the only post-login value is a bearer token", "the only stable per-user values are the PIN and the recovery phrase") — never the value itself — so the developer can see what was considered and why it was refused.

## 1. What counts as real

- **`visitorId`** — the signed-in end user's identity: a value read at runtime from an authenticated session (an API response field, a decoded JWT claim like `sub`, a persisted user record's primary key). Never a value the app itself invents fresh with no backing record, and never a value that authenticates (§0 Rule 2) — the decoded `sub` claim qualifies, the JWT it was decoded from does not.
- **`accountId`** — the user's organization/tenant/company/workspace, if the app has that concept at all. Many consumer apps don't — see §4's empty-account values.
- **Anonymous / no-login apps**: a persisted, stable device- or install-scoped identifier (Keychain-backed UUID on iOS, `SharedPreferences`-backed UUID on Android, `expo-secure-store`/`AsyncStorage`-backed UUID on RN/Expo, `flutter_secure_storage`-backed UUID on Flutter, `SecureStorage`-backed on MAUI) *may* be an acceptable `visitorId` substitute — but only if it's genuinely persisted and stable across app launches, not regenerated each time the app starts (a fresh-per-launch UUID is the same "garbage analytics" failure mode Rule 1 warns about, just self-inflicted instead of copy-pasted), **and** only if it is a label rather than a credential: a device UUID the backend accepts as proof of identity (a device token, a registration secret) is excluded by §0 Rule 2 no matter how stable it is. This is a judgment call: flag the choice under "Requires your attention" rather than making it silently.

## 2. Search targets

Look for these, roughly in order of how likely each is to be the app's actual identity source:

**Auth SDKs / providers** — Firebase Auth (`FirebaseAuth`/`currentUser`/`onAuthStateChanged`), AWS Amplify / Cognito, Auth0 (`Auth0.shared`, `CredentialsManager`), Okta, Supabase Auth (`supabase.auth.getUser()`), Sign in with Apple (`ASAuthorizationAppleIDCredential`), Google Sign-In, a custom backend login endpoint returning a token + user object.

**Session/credential storage** — Keychain (iOS/MAUI-iOS), `EncryptedSharedPreferences`/Jetpack `DataStore`/Android Keystore, `AsyncStorage`/`expo-secure-store` (RN/Expo), `flutter_secure_storage` (Flutter), `SecureStorage`/`Preferences` (MAUI/.NET MAUI Essentials). **Search these for the identifier stored *alongside* the credential — never for the credential itself.** These stores exist to hold tokens and keys, so they are the likeliest place in the whole app to find a §0 Rule 2 violation sitting in plain sight under a promising-looking key name. A `userId` or `email` persisted next to the token is a real identifier; the token, refresh token, or key stored under the adjacent entry is not, whatever it is named.

**App-level "current user" sources** — a `User`/`Account`/`Profile` model with an `id`/`userId`/`email` field; an `Organization`/`Account`/`Tenant`/`Workspace`/`Company` model with an `id`/`accountId`/`orgId`/`tenantId` field; a singleton/service/store named `AuthManager`, `SessionManager`, `UserManager`, `AuthViewModel`, `AuthRepository`, `AuthContext`, or a hook/composable named `useAuth`/`useUser`/`useSession`; state-management slices literally named `auth`, `user`, or `session` (Redux, Zustand, Context+`useReducer`, Provider, Riverpod, MobX, Bloc/Cubit).

**Per-platform greppable patterns**:

| Platform | Grep for |
|---|---|
| iOS (UIKit/SwiftUI) | `currentUser`, `AuthManager`, `SessionManager`, `Keychain`, `@Published var user`, `ASAuthorizationAppleIDCredential`, `FirebaseAuth.auth()` |
| Android (Kotlin/Java) | `currentUser`, `AuthRepository`, `SharedPreferences`, `DataStore`, `FirebaseAuth.getInstance()`, `LiveData<User>`, `StateFlow<User>` |
| React Native / Expo | `AsyncStorage.getItem`, `SecureStore.getItemAsync`, `useAuth(`, `useUser(`, `AuthContext`, `onAuthStateChanged`, a Redux/Zustand slice named `auth`/`user` |
| Flutter | `SharedPreferences`, `flutter_secure_storage`, `FirebaseAuth.instance.currentUser`, a Provider/Riverpod/Bloc class named `AuthState`/`UserState`/`AuthCubit` |
| MAUI | `SecureStorage.GetAsync`, `Preferences.Get`, `IAuthService`, `AuthenticationService`, a `CurrentUser` property, `LoginViewModel` |

## 3. Placement priority for `startSession`

Search in this order; wire the call at the **first** tier that resolves to a real identifier. Do not fall further down the list once one tier matches.

**A tier matches only when it yields a usable identifier — not when the code shape is present.** Finding a login callback is not a match; finding a *real, non-credential* identifier inside one is. A tier that produces only values §0 Rule 2 excludes has **not** matched, and the search continues to the next tier exactly as if that code did not exist.

1. **Post-login callback** (best) — the handler that runs immediately after a successful sign-in: the `.then()`/`await` continuation of a login API call, a `signInWithEmailAndPassword(...).then(user => ...)`-style callback, an `onLoginSuccess`/`handleLoginSuccess` function. An identifier found here is freshly resolved and real. **But read what the callback actually resolves before taking it.** A login response commonly carries both a credential and an identifier — take the identifier (`user.id`, `sub`, `email`, the profile record) and never the token beside it. Some backends return *only* credentials: an app that authenticates against the user's own server, a device-pairing flow, a wallet or node login that yields nothing but an access token and a refresh token. That is not a tier-1 match at all — it is a credential-only callback, and the tempting values around it (a PIN, a stored recovery phrase, a private key) are the ones Rule 2 most specifically forbids. Move to tier 2.
2. **Session init after auth resolves** — a cold-start auth-state listener that fires once existing credentials are checked (Firebase's `onAuthStateChanged`, a root navigator awaiting `checkAuthStatus()` before routing to the authenticated stack). Slightly later than login but still only fires once identity is known.
3. **Token refresh/restore** — an app that restores a persisted session/token on cold start and only resolves identity as a side effect of that refresh (no separate "auth resolved" event exists apart from the refresh call itself). Use this tier only when neither of the above exists.
4. **Main app init** (last resort) — alongside `setup()`, at the platform's standard app-init point. Use this only when the app has no distinguishable auth-resolution moment at all, or is genuinely anonymous end-to-end (see §1's anonymous-app allowance). Flag this placement explicitly under "Requires your attention" even when it succeeds — it's the weakest option, and the developer should confirm identity is actually available by the time this code path runs rather than assuming it.

If no tier produces a real identifier, follow §0's shared fallback: `setup()` only, no `startSession` call, report what's missing.

### When auth sits behind an interface, a flavor, or a DI binding

A tier can resolve a perfectly good identifier and still leave the app uninstrumented, because **the call was wired into one implementation of the auth abstraction and the app ships several.** Real apps routinely do: an `AuthRepositoryRemote` beside an `AuthRepositoryDev` or `AuthRepositoryFake`, a `dev`/`staging`/`prod` flavor split with its own entry point each, an offline or demo mode, a `#if DEBUG` branch. Wire the real one and stop, and `startSession` never runs in the flavor the team actually develops against — while the build passes and the diff looks correct. Nothing downstream catches it, which puts it in the same class as §0's two hard rules.

Before settling on a call site:

1. **Enumerate the alternatives.** Search for other types implementing the same auth interface/protocol/abstract class, and for every place one is *bound*: DI module and provider registrations, factory functions, `@Provides`/`@Binds`, provider lists passed at app startup, and per-flavor entry points (`main_dev.dart`/`main_staging.dart`, product flavors, build configurations, scheme-specific `Info.plist`s).
2. **Wire every implementation that resolves a real identifier**, at the equivalent point in each. These are alternative bindings — only one is live in any given build — so wiring each of them does not produce two calls in one run.
3. **Do not invent an identifier for the ones that lack one.** A dev or mock implementation that returns no user id gets no call, per Rule 1. Name it in the report instead.
4. **Check the cold-start path as its own case.** An app that restores a persisted session on launch frequently never re-resolves the identity behind it — it persisted the *token* and discarded the user id. Then `startSession` fires on the first login and on no launch afterwards, which is the majority of launches. Where that is the shape, prefer a single call site covering both routes: the point where the session becomes known, whether it arrived from a fresh login or from a restored credential (a `/me` call, a decoded token claim, a hydrated user record). If no such point exists, say so rather than accepting first-login-only coverage silently.

Report every implementation and every launch path you did **not** wire, and why, under §5. A partially-wired identity is not a completed install, and unlike a missing call it is invisible in a diff.

## 4. Per-platform empty-account values (inferred, not corpus-stated)

Applies only when the app has **no** account/organization/tenant concept at all (visitor-only apps) — `visitorId` is still real and required, but there is no account value to pass.

**Pendo's docs do not specify an empty-account convention for any platform.** The table below is inference from each platform's declared `startSession` parameter types (sourced from each platform's `api-documentation/*-apis.md`), not a Pendo-stated requirement. What matters is passing a value of the type the signature actually declares — an empty string, an empty collection, or (where the parameter is nullable) `null` — not any one specific literal:

| Platform | `accountId` type | `accountData` type | An empty value that satisfies the type |
|---|---|---|---|
| iOS | `String?` | `[AnyHashable : Any]?` | `""` / `[:]` |
| Android | `String` | `Map<String, Object>` | `""` / `null` |
| React Native / Expo | `string?` | `object?` | `''` / `{}` |
| Flutter | `String?` | `Map<String, dynamic>?` | `""` / `{}` |
| MAUI | `string` | `Dictionary<string, object>` | `""` / `new Dictionary<string, object>()` |

These are illustrative, not mandatory — any other empty value of the same declared type (e.g. Android's `accountData` could equally be an empty map instead of `null`) satisfies the signature just as well. Values don't carry across platforms because the declared types themselves differ per platform, not because one specific empty literal is required.

## 5. Reporting when unwired or partly wired

### When `startSession` is left unwired entirely (§0's shared fallback)

The reference file's "Requires your attention" line back to Phase 8 must state exactly:
- which tiers (§3) were searched and found nothing,
- what kind of identifier the app appears to be missing (e.g. "no auth SDK or session storage found — app may be anonymous, or auth lives in a module outside the scanned paths"),
- **which route produced the fallback** — no identifier at all, or identity-shaped values that were all credentials excluded by §0 Rule 2. In the second case, name the *kind* of value rejected and never the value itself: "the login endpoint returns only an access token and a refresh token; the only other stable per-user values in the app are the local PIN and the recovery phrase, all of which are credentials." A developer who is not told this will assume the search simply missed something and will point you back at the same values.
- what the developer must supply: a real `visitorId` source and, if applicable, a real `accountId` source, plus the file/function where the call should go once available.

### When `startSession` is wired, but not everywhere

State it plainly rather than reporting a clean install (§3's DI/flavor subsection):
- which auth implementations, bindings, or flavor entry points **do** reach the call, and which do not,
- whether a cold start with a restored session reaches it, or only a fresh login,
- what the developer must add for the uncovered paths — the identifier source each one is missing, not just the fact that it is missing.
