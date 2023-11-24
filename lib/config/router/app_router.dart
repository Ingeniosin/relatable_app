import 'package:go_router/go_router.dart';

import '../../presentation/providers/chat_provider.dart';
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
    GoRoute(
      path: '/create-chat',
      name: CreateChatScreen.name,
      builder: (context, state) => const CreateChatScreen(),
    ),
    GoRoute(
      path: '/chat',
      name: ChatScreen.name,
      builder: (context, state) {
        Chat chat = state.extra as Chat;
        return ChatScreen(chat: chat);
      },
    ),
  ],
);
