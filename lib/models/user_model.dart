enum AuthMethod { google, email, facebook }

enum AppLanguage { th, en }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final AuthMethod authMethod;
  final AppLanguage language;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.authMethod,
    required this.language,
    required this.createdAt,
  });
}
