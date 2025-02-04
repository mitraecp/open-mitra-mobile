// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectConfigModel {
  String color;
  String icon;

  ProjectConfigModel({
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color,
      'icon': icon,
    };
  }

  factory ProjectConfigModel.fromMap(Map<String, dynamic> map) {
    return ProjectConfigModel(
      color: map['color'] as String,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectConfigModel.fromJson(String source) => ProjectConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);
  
}
