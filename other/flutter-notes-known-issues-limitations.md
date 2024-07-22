

## Navigation Libraries
Currently, the page recognition solution supports the standard Flutter Navigator and GoRouter libraries. Integration with additional navigation frameworks is planned for future releases.
When using GoRouter with nested routes, ensure each branch includes a PendoNavigationObserver() to accurately track route changes and enable proper element detection.

## Clickable Elemnts
The current implementation supports basic touch interactions (down and up) on a range of standard Flutter widgets, including:
InkResponse, InkWell, GestureDetector
ButtonStyleButton, FloatingActionButton, IconButton, MaterialButton
PopupMenuButton, DropdownButton, Checkbox, Chip, ChoiceChip, FilterChip, InputChip, Switch, Radio, ListTile
TabBar, BottomNavigationBar, SelectableText, TextField
Support for more complex interaction types (e.g. drag, swiped) is planned for future releases.

## Dynamic Elements
Currently, the solution primarily focuses on statically defined UI elements. Dynamic elements, such as those created after the initial page render or located outside the visible viewport, may not be detected reliably.
Widgets that are located below the fold are not supported in this phase.

## KNOWN ISSUES
- GoRouter Nested Branches: In some cases, navigating between bottom tab bar routes within a GoRouter nested branch might disrupt element tracking

- We're aware of an issue where the on-screen keyboard triggers additional processing within the SDK, which may cause performance issues

- Upgrading existing applications using the track-event solution will take 24 hours to complete.
