

## Navigation Libraries
The Page recognition solution supports the standard Flutter Navigator, GoRouter and AutoRoute libraries. Integration with additional navigation frameworks is planned for future releases.

## Clickable Widgets
Our implementation supports basic touch interactions (touchDown and touchUp) on a range of standard Flutter widgets, including:<br>
InkResponse, InkWell, GestureDetector<br>
ButtonStyleButton, FloatingActionButton, IconButton, MaterialButton<br>
PopupMenuButton, DropdownButton, Checkbox, Chip, ChoiceChip, FilterChip, InputChip, Switch, Radio, ListTile<br>
TabBar, BottomNavigationBar, SelectableText, TextField<br>

## Known Issues
Drag and Swipe gestures support is planned for future releases.

The `material_ui` and `cupertino_ui` packages (Flutter 3.47 and later) are not supported yet. Pendo supports the Material and Cupertino widgets that ship with the Flutter SDK (`package:flutter/material.dart` and `package:flutter/cupertino.dart`). Support for the new packages is planned for a future release.
