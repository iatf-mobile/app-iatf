import 'package:flutter/foundation.dart';

/// Estado da tela de login.
class LoginState {
  final String email;
  final String password;
  final bool isVet;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isVet = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isVet,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isVet: isVet ?? this.isVet,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel da tela de login
class LoginViewModel extends ChangeNotifier {
  LoginState _state = const LoginState();

  /// Expõe apenas a leitura do estado para a View
  LoginState get state => _state;

  // Handlers de entrada
  void onEmailChanged(String value) {
    _state = _state.copyWith(email: value, clearError: true);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(password: value, clearError: true);
    notifyListeners();
  }

  void onVetToggled(bool value) {
    _state = _state.copyWith(isVet: value);
    notifyListeners();
  }

  void onTogglePasswordVisibility() {
    _state = _state.copyWith(isPasswordVisible: !_state.isPasswordVisible);
    notifyListeners();
  }

  // Ações

  Future<void> onLoginPressed() async {
    final error = _validate();
    if (error != null) {
      _state = _state.copyWith(errorMessage: error);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      // TODO: injetar AuthRepository e chamar o login real.
      // Ex: await _authRepository.login(email: _state.email, password: _state.password);
      await Future.delayed(const Duration(seconds: 2)); // simulação
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao entrar. Verifique seus dados.',
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> onGoogleLoginPressed() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      // TODO: implementar Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  void onForgotPasswordPressed() {
    // TODO: navegar para tela de recuperação de senha
  }

  void onRegisterPressed() {
    // TODO: navegar para tela de cadastro
  }

  /// Retorna uma mensagem de erro ou null se válido
  String? _validate() {
    if (_state.email.trim().isEmpty) return 'Informe seu e-mail.';
    if (!_state.email.contains('@')) return 'E-mail inválido.';
    if (_state.password.length < 8) return 'Senha deve ter ao menos 8 caracteres.';
    return null;
  }
}