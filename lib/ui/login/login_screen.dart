import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginView(),
    );
  }
}

// View principal
class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                // surfaceContainerLowest é o branco/quase-branco do Material 3
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DoctorAvatar(),
                  SizedBox(height: 20),
                  _WelcomeHeader(),
                  SizedBox(height: 28),
                  _EmailField(),
                  SizedBox(height: 14),
                  _PasswordField(),
                  _ForgotPasswordButton(),
                  SizedBox(height: 16),
                  _VetToggleRow(),
                  SizedBox(height: 24),
                  _ErrorMessage(),
                  _LoginButton(),
                  SizedBox(height: 14),
                  _GoogleLoginButton(),
                  SizedBox(height: 20),
                  _RegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widgets privados
class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: isDarkMode ? cs.secondary : cs.secondaryContainer
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/doctor_avatar_1000.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'Bem Vindo',
          style: tt.displaySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Acesse sua conta para continuar',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    return TextFormField(
      onChanged: vm.onEmailChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        cs: Theme.of(context).colorScheme,
        label: 'Email',
        hint: 'seuemail@gmail.com',
        prefixIcon: Icons.person_outline_rounded,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final isVisible = context.select<LoginViewModel, bool>(
      (vm) => vm.state.isPasswordVisible,
    );
    final vm = context.read<LoginViewModel>();
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      onChanged: vm.onPasswordChanged,
      obscureText: !isVisible,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(
        cs: cs,
        label: 'Senha',
        hint: 'Digite sua senha',
        prefixIcon: Icons.vpn_key_outlined,
        suffix: GestureDetector(
          onTap: vm.onTogglePasswordVisibility,
          child: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: cs.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: context.read<LoginViewModel>().onForgotPasswordPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        child: const Text('Esqueceu a senha?', style: TextStyle(fontSize: 13)),
      ),
    );
  }
}

class _VetToggleRow extends StatelessWidget {
  const _VetToggleRow();

  @override
  Widget build(BuildContext context) {
    final isVet = context.select<LoginViewModel, bool>((vm) => vm.state.isVet);
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Veterinário(a)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch.adaptive(
            value: isVet,
            onChanged: context.read<LoginViewModel>().onVetToggled,
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    final error = context.select<LoginViewModel, String?>(
      (vm) => vm.state.errorMessage,
    );

    if (error == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        error,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<LoginViewModel, bool>(
      (vm) => vm.state.isLoading,
    );

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading
            ? null
            : context.read<LoginViewModel>().onLoginPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Entrar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: context.read<LoginViewModel>().onGoogleLoginPressed,
        icon: SvgPicture.asset(
          'assets/icons/icon_google.svg',
          width: 24,
          height: 24,
          errorBuilder: (_, _, _) => const Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.red,
            size: 24,
          ),
        ),
        label: Text(
          'Entrar com Google',
          style: TextStyle(
            fontSize: 14,
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: context.read<LoginViewModel>().onRegisterPressed,
          child: Text(
            'Cadastre-se',
            style: TextStyle(
              fontSize: 14,
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper top-level
InputDecoration _inputDecoration({
  required ColorScheme cs,
  required String label,
  required String hint,
  required IconData prefixIcon,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(color: cs.outline, fontSize: 14),
    labelStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
    prefixIcon: Icon(prefixIcon, color: cs.onSurfaceVariant, size: 20),
    suffixIcon: suffix != null
        ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
        : null,
    suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    filled: true,
    fillColor: cs.surfaceContainerLowest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.primary, width: 1.8),
    ),
  );
}
