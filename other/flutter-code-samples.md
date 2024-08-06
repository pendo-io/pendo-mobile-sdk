

The following example demonstrates Go_router integration with nested branches 
```dart 
import 'package:pendo_sdk/pendo_sdk.dart';
class NestedTabNavigationWidget extends StatelessWidget { 
    NestedTabNavigationExampleApp({super.key});

    static NestedBranchesObserver nestedBranchesObserver = NestedBranchesObserver(); // create NestedBranchesObserver()

    final GoRouter _router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/a',
        routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
            },
            branches: <StatefulShellBranch>[
                StatefulShellBranch(
                observers: [], 
                navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                //Your routes 
                ],
            ),
            StatefulShellBranch(
                observers: [], 
                routes: <RouteBase>[
                //Your routes
                ],
            ),
            ],
        ),
        ],
        observers: [], 
    );

    @override
    Widget build(BuildContext context) {
        nestedBranchesObserver.addListener(_router); // listen to router changes
        return MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: _router,
        );
    }

    // In case your class extends a StatefulWidget add this @override dispose() method
    @override
    void dispose() {
        pendoNestedBranchesObserver.removeListener(_router); // removing listener
        super.dispose();
    }
}
```

