// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BaseUrlMitraModel {
  String name;
  String link;
  BaseUrlMitraModel({
    required this.name,
    required this.link,
  });

  BaseUrlMitraModel copyWith({
    String? name,
    String? link,
  }) {
    return BaseUrlMitraModel(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
    };
  }

  factory BaseUrlMitraModel.fromMap(Map<String, dynamic> map) {
    return BaseUrlMitraModel(
      name: map['name'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseUrlMitraModel.fromJson(String source) =>
      BaseUrlMitraModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BaseUrlMitraModel(name: $name, link: $link)';

  @override
  bool operator ==(covariant BaseUrlMitraModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}
