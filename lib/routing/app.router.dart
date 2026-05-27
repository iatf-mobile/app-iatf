import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iatf_mobile/ui/core/ui/main_screen.dart';
import 'package:iatf_mobile/ui/protocols/protocols_screen.dart';
import '../ui/login/login_screen.dart';
import '../ui/register/register_screen.dart';
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
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.protocols, 
      builder: (context, state) => const ProtocolsScreen(),
      ),
  ],
);