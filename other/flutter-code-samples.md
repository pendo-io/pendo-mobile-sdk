

The following exmaple demonstrates Pendo integartion with nested branches 
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
                observers: [PendoNavigationObserver(),], // add PendoNavigationObserver() to observers
                navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                //Your routes 
                ],
            ),
            StatefulShellBranch(
                observers: [PendoNavigationObserver(),], // add PendoNavigationObserver() to observers
                routes: <RouteBase>[
                //Your routes
                ],
            ),
            ],
        ),
        ],
        observers: [PendoNavigationObserver(),], // add PendoNavigationObserver() to observers
    );

    @override
    Widget build(BuildContext context) {
        nestedBranchesObserver.addListener(_router); // listen to router chsnges
        return MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: _router,
        );
    }

    @override
    void dispose() {
        pendoNestedBranchesObserver.removeListener(_router); // removing listener
        super.dispose();
    }
}
```

