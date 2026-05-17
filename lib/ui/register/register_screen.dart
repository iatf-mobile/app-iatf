import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'register_view_model.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterView(),
    );
  }
}

// View principal
class _RegisterView extends StatelessWidget {
  const _RegisterView();

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
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withAlpha(50),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _VetAvatar(),
                  SizedBox(height: 20),
                  _RegisterHeader(),
                  SizedBox(height: 28),
                  _NameField(),
                  SizedBox(height: 14),
                  _EmailField(),
                  SizedBox(height: 14),
                  _PasswordField(),
                  SizedBox(height: 16),
                  _VetToggleRow(),
                  SizedBox(height: 24),
                  _ErrorMessage(),
                  _RegisterButton(),
                  SizedBox(height: 20),
                  _LoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Avatar
class _VetAvatar extends StatelessWidget {
  const _VetAvatar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? cs.secondary : cs.secondaryContainer,
      ),
      child: ClipOval(
        child: Image.asset('assets/images/vet_avatar.png', fit: BoxFit.cover),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'Cadastrar',
          style: tt.headlineMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Crie sua conta para continuar',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: context.read<RegisterViewModel>().onNameChanged,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        cs: Theme.of(context).colorScheme,
        label: 'Nome',
        hint: 'Digite seu nome',
        prefixIcon: Icons.person_outline_rounded,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: context.read<RegisterViewModel>().onEmailChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        cs: Theme.of(context).colorScheme,
        label: 'Email',
        hint: 'seuemail@gmail.com',
        prefixIcon: Icons.email_outlined,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final isVisible = context.select<RegisterViewModel, bool>(
      (vm) => vm.state.isPasswordVisible,
    );
    final vm = context.read<RegisterViewModel>();
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

class _VetToggleRow extends StatelessWidget {
  const _VetToggleRow();

  @override
  Widget build(BuildContext context) {
    final isVet = context.select<RegisterViewModel, bool>(
      (vm) => vm.state.isVet,
    );
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
            onChanged: context.read<RegisterViewModel>().onVetToggled,
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
    final error = context.select<RegisterViewModel, String?>(
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

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<RegisterViewModel, bool>(
      (vm) => vm.state.isLoading,
    );

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading
            ? null
            : context.read<RegisterViewModel>().onRegisterPressed,
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
                'Cadastrar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta? ',
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: context.read<RegisterViewModel>().onLoginPressed,
          child: Text(
            'Entre aqui',
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
