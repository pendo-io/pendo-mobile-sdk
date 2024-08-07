

The following example demonstrates GoRouter integration 
```dart 
import 'package:pendo_sdk/pendo_sdk.dart';
    
    class _AppState extends State<App> {
        final GoRouter _router = generateRouter(); // Your GoRouter instance 
        static final NestedBranchesObserver _pendoGoRouterObserver = NestedBranchesObserver(); // Pendo observer for the GoRouter

        addRouterToPendoObserver() {
            _pendoGoRouterObserver.removeListener(_router); 
            _pendoGoRouterObserver.addListener(_router);
        }

        @override
        Future<void> dispose() async {
            _pendoGoRouterObserver.removeListener(_router);
            super.dispose();
        }

        @override
        Widget build(BuildContext context) {
            addRouterToPendoObserver(); // Add your GoRouter instance to the Pendo observer 
            return PendoActionListener(
                child: MaterialApp.router(
                routerConfig: _router,
                ),
            );
        }
    }
```

