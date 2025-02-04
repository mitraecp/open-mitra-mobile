// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MergeModel {
  String? backURL;
  String? frontURL;
  String? userEmail;
  String? userToken;

  MergeModel({
    this.backURL,
    this.frontURL,
    this.userEmail,
    this.userToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'backURL': backURL,
      'frontURL': frontURL,
      'userEmail': userEmail,
      'userToken': userToken,
    };
  }

  factory MergeModel.fromMap(Map<String, dynamic> map) {
    return MergeModel(
      backURL: map['backURL'] != null ? map['backURL'] as String : null,
      frontURL: map['frontURL'] != null ? map['frontURL'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userToken: map['userToken'] != null ? map['userToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MergeModel.fromJson(String source) =>
      MergeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
