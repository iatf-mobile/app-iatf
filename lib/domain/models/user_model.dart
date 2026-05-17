/// Representa o usuário autenticado no sistema
class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isVet;
  final String? token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isVet,
    this.token,
  });

  /// Cria uma cópia do modelo com campos alterados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isVet,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isVet: isVet ?? this.isVet,
      token: token ?? this.token,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, isVet: $isVet)';
}