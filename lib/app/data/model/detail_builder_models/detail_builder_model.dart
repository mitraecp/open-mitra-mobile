// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetailBuilderModel {
  String name;
  int id;
  DetailBuilderModel({
    required this.name,
    required this.id,
  });

  DetailBuilderModel copyWith({
    String? name,
    int? id,
  }) {
    return DetailBuilderModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory DetailBuilderModel.fromMap(Map<String, dynamic> map) {
    return DetailBuilderModel(
      name: map['name'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailBuilderModel.fromJson(String source) =>
      DetailBuilderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DetailBuilderModel(name: $name, id: $id)';

  @override
  bool operator ==(covariant DetailBuilderModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
