// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthUserModel {
  String email;
  String password;
  String? name;

  AuthUserModel({
    required this.email,
    required this.password,
    this.name,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name ?? '';
    data['password'] = password;
    return data;
  }

  @override
  String toString() =>
      'AuthUserModel(email: $email, password: $password, name: $name)';
}
