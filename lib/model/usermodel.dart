// model/usermodel.dart
class UserModel {
  final String? id;
  final String phonenumber;
  final String name;
  final String? phonenumberError;
  final String? nameError;

  UserModel({
    this.id,
    required this.phonenumber,
    this.name = '',
    this.phonenumberError,
    this.nameError,
  });

  UserModel copyWith({
    String? id,
    String? phonenumber,
    String? name,
    String? phonenumberError,
    String? nameError,
  }) {
    return UserModel(
      id: id ?? this.id,
      phonenumber: phonenumber ?? this.phonenumber,
      name: name ?? this.name,
      phonenumberError: phonenumberError,
      nameError: nameError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phonenumber': '+91$phonenumber',
      'name': name,
    };
  }

  bool get isValid {
    return phonenumberError == null && nameError == null;
  }
}
