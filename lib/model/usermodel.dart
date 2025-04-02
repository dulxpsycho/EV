// model/usermodel.dart
class UserModel {
  final String? id;
  final String email;
  final String password;
  final String name;
  final String? emailError;
  final String? passwordError;
  final String? nameError;

  UserModel(
      {this.id,
      this.name = '',
      this.email = '',
      this.password = '',
      this.emailError,
      this.passwordError,
      this.nameError});
  UserModel copyWith(
      {String? id,
      String? email,
      String? password,
      String? name,
      String? emailError,
      String? passwordError,
      String? nameError}) {
    return UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        emailError: emailError,
        passwordError: passwordError,
        nameError: nameError);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  bool get isValid {
    return emailError == null && passwordError == null && nameError == null;
  }
}
