// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/activated_screen.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/inacticated_screen.dart';


class ProjectScreenModel {
  int id;
  String name;
  List<ActivatedScreenModel>? activatedScreens;
  List<InactivatedScreenModel>? inactivatedScreens;

  // Usado so no front
  RxBool? accordionProjectFolderSelected = false.obs;

  ProjectScreenModel({
    required this.id,
    required this.name,
    this.activatedScreens,
    this.inactivatedScreens,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'activatedScreens': activatedScreens?.map((x) => x.toMap()).toList(),
      'inactivatedScreens': inactivatedScreens?.map((x) => x.toMap()).toList(),
    };
  }

  factory ProjectScreenModel.fromMap(Map<String, dynamic> map) {
    return ProjectScreenModel(
      id: map['id'] as int,
      name: map['name'] as String,
      activatedScreens: map['activatedScreens'] != null &&
              map['activatedScreens'] is List
          ? List<ActivatedScreenModel>.from(
              (map['activatedScreens'] as List<dynamic>)
                  .map<ActivatedScreenModel?>(
                (x) => ActivatedScreenModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      inactivatedScreens: map['inactivatedScreens'] != null &&
              map['inactivatedScreens'] is List
          ? List<InactivatedScreenModel>.from(
              (map['inactivatedScreens'] as List<dynamic>)
                  .map<InactivatedScreenModel?>(
                (x) =>
                    InactivatedScreenModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectScreenModel.fromJson(String source) =>
      ProjectScreenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectScreenModel(id: $id, name: $name, activatedScreens: $activatedScreens, inactivatedScreens: $inactivatedScreens, accordionProjectFolderSelected: $accordionProjectFolderSelected)';
  }
}
