import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/detail/detail_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/favorite/favorite_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

Future<bool> _isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_logged_in') ?? false;
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) async {
    final loggedIn = await _isLoggedIn();
    final goingToLogin = state.matchedLocation == '/login';

    if (!loggedIn && !goingToLogin) return '/login';
    if (loggedIn && goingToLogin) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return DetailScreen(movieId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoriteScreen(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/favorite')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/favorite');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _locationToIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
      ),
    );
  }
}
