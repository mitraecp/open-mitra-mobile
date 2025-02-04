// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoryMobileScreenModel {
  int id;
  String name;
  HistoryMobileScreenModel({
    required this.id,
    required this.name,
  });

  HistoryMobileScreenModel copyWith({
    int? id,
    String? name,
  }) {
    return HistoryMobileScreenModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory HistoryMobileScreenModel.fromMap(Map<String, dynamic> map) {
    return HistoryMobileScreenModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryMobileScreenModel.fromJson(String source) =>
      HistoryMobileScreenModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HistoryMobileScreenModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant HistoryMobileScreenModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
