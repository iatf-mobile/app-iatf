import 'package:flutter/foundation.dart';

/// Estado imutável
class RegisterState {
  final String name;
  final String email;
  final String password;
  final bool isVet;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isVet = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isVet,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isVet: isVet ?? this.isVet,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel da tela de cadastro
class RegisterViewModel extends ChangeNotifier {
  RegisterState _state = const RegisterState();

  RegisterState get state => _state;

  // Handlers de entrada
  void onNameChanged(String value) {
    _state = _state.copyWith(name: value, clearError: true);
    notifyListeners();
  }

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

  Future<void> onRegisterPressed() async {
    final error = _validate();
    if (error != null) {
      _state = _state.copyWith(errorMessage: error);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      // TODO: injetar AuthRepository e chamar o cadastro real.
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'Erro ao cadastrar. Tente novamente.',
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  void onLoginPressed() {
    // TODO: navegar de volta para a tela de login
  }

  // Privados
  String? _validate() {
    if (_state.name.trim().isEmpty) return 'Informe seu nome.';
    if (_state.name.trim().length < 2) return 'Nome muito curto.';
    if (_state.email.trim().isEmpty) return 'Informe seu e-mail.';
    if (!_state.email.contains('@')) return 'E-mail inválido.';
    if (_state.password.length < 8) return 'Senha deve ter ao menos 8 caracteres.';
    return null;
  }
}