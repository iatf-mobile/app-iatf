import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/login/login_screen.dart';
import '../ui/register/register_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/profile/profile_screen.dart';
import 'app_routes.dart';

/// Configuração central de navegação do app
final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,

  /// Lógica de autenticação
  redirect: (BuildContext context, GoRouterState state) {
    // TODO: substituir por verificação real do AuthRepository
    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);