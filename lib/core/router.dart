import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/home/presentation/pages/start_page.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart';
import 'package:typing_game/features/typing_game/presentation/pages/typing_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
// final GlobalKey<NavigatorState> _shellNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const StartPage();
      },
    ),
    GoRoute(
      path: '/typing/:mode/:level',
      builder: (BuildContext context, GoRouterState state) {
        final level = state.pathParameters['level']!;
        final mode = state.pathParameters['mode']!;
        final wordCount = (mode == 'limit') ? 999 : 100;

        // TypingPageに遷移する際にChangeNotifierProviderを適用
        return ChangeNotifierProvider(
          create: (_) => TypingController(),
          child: TypingPage(level: level, mode: mode, wordCount: wordCount),
        );
      },
    ),
    // TODO: ログイン画面へのルートを追加
    // GoRoute(
    //   path: '/login',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const LoginPage(); // LoginPageは別途作成する必要あり
    //   },
    // ),
  ],
  // エラーページを定義することも可能
  // errorBuilder: (context, state) => ErrorScreen(error: state.error),
);

// ルート名を定義しておくと、タイポを防ぎやすくなります（任意）
// class AppRoutes {
//   static const String home = '/';
//   static const String typing = '/typing';
//   static String typingWithParams(String level, String mode, int wordCount) =>
//       '/typing/$level/$mode/$wordCount';
//   static const String login = '/login';
// }
