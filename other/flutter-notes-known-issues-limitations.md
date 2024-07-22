

## Navigation Libraries
The page recognition solution supports the standard Flutter Navigator and GoRouter libraries. Integration with additional navigation frameworks is planned for future releases.

## Clickable Widgets
Our implementation supports basic touch interactions (touchDown and touchUp) on a range of standard Flutter widgets, including:<br>
InkResponse, InkWell, GestureDetector<br>
ButtonStyleButton, FloatingActionButton, IconButton, MaterialButton<br>
PopupMenuButton, DropdownButton, Checkbox, Chip, ChoiceChip, FilterChip, InputChip, Switch, Radio, ListTile<br>
TabBar, BottomNavigationBar, SelectableText, TextField<br>
Support for more complex interaction types (e.g. Drag and Swipe gestures) is planned for future releases.

## Dynamic Widgets
Currently, the solution primarily focuses on statically defined UI elements. Dynamic elements, such as those created after the initial page render or located outside the visible viewport, may not be detected reliably.
Widgets that are located below the fold are not supported in this phase.

## Known Issues
- Different tabs within TabBar or BottomNavigationBar are not detected as independent pages.

- GoRouter Nested Branches: In some cases, navigating between bottom tab bar routes within a GoRouter nested branch might disrupt element tracking.

- We're aware of an issue where the on-screen keyboard triggers additional processing within the SDK, which may cause performance issues.
