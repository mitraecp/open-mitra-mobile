// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:open_mitra_mobile/app/data/model/projects_models/merge_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/last_access_view.dart';


class RefreshTokenModel {
  String accessType;
  LastAccessView? lastAccessView;
  MergeModel? merge;
  String token;
  String type;
  
  RefreshTokenModel({
    required this.accessType,
    this.lastAccessView,
    this.merge,
    required this.token,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessType': accessType,
      'lastAccessView': lastAccessView?.toMap(),
      'merge': merge?.toMap(),
      'token': token,
      'type': type,
    };
  }

  factory RefreshTokenModel.fromMap(Map<String, dynamic> map) {
    return RefreshTokenModel(
      accessType: map['accessType'] as String,
      lastAccessView: map['lastAccessView'] != null &&
              map['lastAccessView'] is Map<String, dynamic>?
          ? LastAccessView.fromMap(
              map['lastAccessView'] as Map<String, dynamic>)
          : null,
      merge: map['merge'] != null
          ? MergeModel.fromMap(map['merge'] as Map<String, dynamic>)
          : null,
      token: map['token'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RefreshTokenModel.fromJson(String source) =>
      RefreshTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RefreshTokenModel(accessType: $accessType, lastAccessView: $lastAccessView, merge: $merge, token: $token, type: $type)';
  }
}
