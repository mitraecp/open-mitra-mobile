//ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SourceComponentModel {
  int id;
  String name;
  dynamic childContents;

  SourceComponentModel({
    required this.id,
    required this.name,
    required this.childContents,
  });

  SourceComponentModel copyWith({
    int? id,
    String? name,
    dynamic childContents,
  }) {
    return SourceComponentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      childContents: childContents ?? this.childContents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'childContents': childContents,
    };
  }

  factory SourceComponentModel.fromMap(Map<String, dynamic> map) {
    return SourceComponentModel(
      id: map['id'] as int,
      name: map['name'] as String,
      childContents: map['childContents'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory SourceComponentModel.fromJson(String source) =>
      SourceComponentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SourceComponentModel(id: $id, name: $name, childContents: $childContents)';

  @override
  bool operator ==(covariant SourceComponentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.childContents == childContents;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ childContents.hashCode;
}
