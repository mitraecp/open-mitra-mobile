// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InactivatedScreenModel {
  bool canPublish;
  bool enableDashMode;
  int id;
  bool isMobile;
  String name;

  InactivatedScreenModel({
    required this.canPublish,
    required this.enableDashMode,
    required this.id,
    required this.isMobile,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canPublish': canPublish,
      'enableDashMode': enableDashMode,
      'id': id,
      'isMobile': isMobile,
      'name': name,
    };
  }

  factory InactivatedScreenModel.fromMap(Map<String, dynamic> map) {
    return InactivatedScreenModel(
      canPublish: map['canPublish'] as bool,
      enableDashMode: map['enableDashMode'] as bool,
      id: map['id'] as int,
      isMobile: map['isMobile'] as bool,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InactivatedScreenModel.fromJson(String source) =>
      InactivatedScreenModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
