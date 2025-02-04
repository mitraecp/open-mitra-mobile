// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkspaceConfigModel {
  String icon;
  WorkspaceConfigModel({
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon,
    };
  }

  factory WorkspaceConfigModel.fromMap(Map<String?, dynamic> map) {
    return WorkspaceConfigModel(
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkspaceConfigModel.fromJson(String source) => WorkspaceConfigModel.fromMap(json.decode(source) as Map<String?, dynamic>);
  

  @override
  String toString() => 'WorkspaceConfigModel(icon: $icon)';
}
