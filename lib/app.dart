import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/assets/asset_detail_screen.dart';
import 'screens/assets/asset_list_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/expenses/expense_list_screen.dart';
import 'screens/liabilities/liability_list_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/types/types_management_screen.dart';
import 'widgets/common/main_shell.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouter _router;
  late final _AuthListenable _authListenable;

  @override
  void initState() {
    super.initState();
    _authListenable = _AuthListenable();
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
            GoRoute(path: '/assets', builder: (_, __) => const AssetListScreen()),
            GoRoute(
              path: '/assets/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                if (id == null) return const AssetListScreen();
                return AssetDetailScreen(assetId: id);
              },
            ),
            GoRoute(path: '/liabilities', builder: (_, __) => const LiabilityListScreen()),
            GoRoute(path: '/expenses', builder: (_, __) => const ExpenseListScreen()),
            GoRoute(path: '/types', builder: (_, __) => const TypesManagementScreen()),
            GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          ],
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = ref.read(authProvider);
        final isGoingToLogin = state.matchedLocation == '/login';
        if (!isLoggedIn && !isGoingToLogin) return '/login';
        if (isLoggedIn && isGoingToLogin) return '/';
        return null;
      },
      refreshListenable: _authListenable,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authListenable._attach(ref);
  }

  @override
  void dispose() {
    _authListenable.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '资产管理',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
    );
  }
}

/// Makes GoRouter re-evaluate the redirect when auth state changes.
class _AuthListenable extends ChangeNotifier {
  ProviderSubscription<bool>? _subscription;

  void _attach(WidgetRef ref) {
    _subscription?.close();
    _subscription = ref.listenManual(authProvider, (_, __) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
