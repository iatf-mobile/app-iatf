import 'package:flutter/foundation.dart';

/// Estado da tela de login.
class LoginState {
  final String email;
  final String password;
  final bool isVet;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isVet = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isVet,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isAuthenticated,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isVet: isVet ?? this.isVet,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
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
      await Future.delayed(const Duration(seconds: 2)); // simulação
      _state = _state.copyWith(isLoading: false, isAuthenticated: true);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao entrar. Verifique seus dados.',
      );
    } finally {
      if (!_state.isAuthenticated) {
        _state = _state.copyWith(isLoading: false);
        notifyListeners();
      }
    }
  }

  Future<void> onGoogleLoginPressed() async {
    _state = _state.copyWith(isLoading: false, clearError: true);
    notifyListeners();

    try {
      // TODO: implementar Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
      _state = _state.copyWith(isLoading: false, isAuthenticated: true);
      notifyListeners();
    } finally {
      if (_state.isAuthenticated) {
        _state = _state.copyWith(isLoading: false);
        notifyListeners();
      }
    }
  }

  void onForgotPasswordPressed() {
    // TODO: navegar para tela de recuperação de senha
  }

  void onRegisterPressed() {}

  /// Retorna uma mensagem de erro ou null se válido
  String? _validate() {
    if (_state.email.trim().isEmpty) return 'Informe seu e-mail.';
    if (!_state.email.contains('@')) return 'E-mail inválido.';
    if (_state.password.length < 8) {
      return 'Senha deve ter ao menos 8 caracteres.';
    }
    return null;
  }
}
