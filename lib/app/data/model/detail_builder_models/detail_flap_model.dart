// ignore_for_file: public_member_api_docs, sort_constructors_first
 import 'dart:convert';
 
 class DetailFlapModel {
   String name;
   int id;
   bool canDeleteInfo;
 
   DetailFlapModel({
     required this.name,
     required this.id,
     required this.canDeleteInfo,
   });
 
   DetailFlapModel copyWith({
     String? name,
     int? id,
     bool? canDeleteInfo,
   }) {
     return DetailFlapModel(
       name: name ?? this.name,
       id: id ?? this.id,
       canDeleteInfo: canDeleteInfo ?? this.canDeleteInfo,
     );
   }
 
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       'name': name,
       'id': id,
       'canDeleteInfo': canDeleteInfo,
     };
   }
 
   factory DetailFlapModel.fromMap(Map<String, dynamic> map) {
     return DetailFlapModel(
       name: map['name'] as String,
       id: map['id'] as int,
       canDeleteInfo: map['canDeleteInfo'] as bool,
     );
   }
 
   String toJson() => json.encode(toMap());
 
   factory DetailFlapModel.fromJson(String source) => DetailFlapModel.fromMap(json.decode(source) as Map<String, dynamic>);
 
   @override
   String toString() => 'DetailFlapModel(name: $name, id: $id, canDeleteInfo: $canDeleteInfo)';
 
   @override
   bool operator ==(covariant DetailFlapModel other) {
     if (identical(this, other)) return true;
   
     return 
       other.name == name &&
       other.id == id &&
       other.canDeleteInfo == canDeleteInfo;
   }
 
   @override
   int get hashCode => name.hashCode ^ id.hashCode ^ canDeleteInfo.hashCode;
 }