import 'package:brasil_card/presentation/features/home/pages/home_page.dart';
import 'package:brasil_card/presentation/features/home/pages/search_page.dart';
import 'package:brasil_card/presentation/features/favorites/pages/favorites_page.dart';
import 'package:brasil_card/presentation/features/crypto/pages/crypto_detail_page.dart';
import 'package:brasil_card/presentation/navigation/main_navigation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String cryptoDetail = '/crypto/:id';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: search,
            pageBuilder:
                (context, state) => const NoTransitionPage(child: SearchPage()),
          ),
          GoRoute(
            path: favorites,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: FavoritesPage()),
          ),
        ],
      ),
      GoRoute(
        path: cryptoDetail,
        builder: (context, state) {
          final cryptoId = state.pathParameters['id']!;
          return CryptoDetailPage(cryptoId: cryptoId);
        },
      ),
    ],
  );
}
