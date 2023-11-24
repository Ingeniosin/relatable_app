import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: LoginEmailScreen.name,
      builder: (context, state) => const LoginEmailScreen(),
    ),
    GoRoute(
      path: '/login-password',
      name: LoginPasswordScreen.name,
      builder: (context, state) => const LoginPasswordScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
