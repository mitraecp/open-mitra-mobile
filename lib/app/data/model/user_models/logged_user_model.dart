// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoggedUser {
  String? email;
  int? id;
  String? language;
  int? lastProjectAccessedId;
  String? name;
  String? picture;
  bool? spacecreation;
  String? userOrigin;

  LoggedUser({
    this.email,
    this.id,
    required this.language,
    this.lastProjectAccessedId,
    this.name,
    this.picture,
    this.spacecreation,
    this.userOrigin,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
      'language': language,
      'lastProjectAccessedId': lastProjectAccessedId,
      'name': name,
      'picture': picture,
      'spacecreation': spacecreation,
      'userOrigin': userOrigin,
    };
  }

  factory LoggedUser.fromMap(Map<String?, dynamic> map) {
    return LoggedUser(
      email: map['email'] as String?,
      id: map['id'] as int?,
      language: map['language'] as String?,
      lastProjectAccessedId: map['lastProjectAccessedId'] as int?,
      name: map['name'] as String?,
      picture: map['picture'] as String?,
      spacecreation: map['spacecreation'] as bool?,
      userOrigin: map['userOrigin'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoggedUser.fromJson(String source) =>
      LoggedUser.fromMap(json.decode(source) as Map<String?, dynamic>);

  @override
  String toString() {
    return 'LoggedUser(email: $email, id: $id, language: $language, lastProjectAccessedId: $lastProjectAccessedId, name: $name, picture: $picture, spacecreation: $spacecreation, userOrigin: $userOrigin)';
  }
}
