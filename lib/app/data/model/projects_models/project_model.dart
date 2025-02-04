// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/mitra_screen.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_config_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_config_model.dart';

class ProjectModel {
  String? accessType;
  List<LoggedUser>? collaboratorProfile;
  int id;
  String? name;
  ProjectConfigModel? projectConfig;
  List<MitraScreen>? screens;
  WorkspaceConfigModel? workSpaceConfig;

  // Usado so no front
  RxBool? accordionListSelected = false.obs;
  Rx<List<ProjectScreenModel>> accordionProjectScreenList = Rx([]);

  ProjectModel({
    required this.accessType,
    this.collaboratorProfile,
    required this.id,
    required this.name,
    required this.projectConfig,
    this.screens,
    this.workSpaceConfig,
  });

  Map<String?, dynamic> toMap() {
    return <String?, dynamic>{
      'accessType': accessType,
      'collaboratorProfile':
          collaboratorProfile?.map((x) => x.toMap()).toList(),
      'id': id,
      'name': name,
      'projectConfigModel': projectConfig?.toMap(),
      'screens': screens?.map((x) => x.toMap()).toList(),
      'workSpaceConfig': workSpaceConfig?.toMap(),
    };
  }

  factory ProjectModel.fromMap(Map<String?, dynamic> map) {
    return ProjectModel(
      accessType: map['accessType'] as String?,
      collaboratorProfile: map['collaboratorProfile'] != null &&
              map['collaboratorProfile'] is List
          ? List<LoggedUser>.from(
              (map['collaboratorProfile'] as List<dynamic>? ?? [])
                  .map<LoggedUser>(
                (x) => LoggedUser.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      id: map['id'] as int,
      name: map['name'] as String?,
      projectConfig: map['projectConfig'] != null &&
              map['projectConfig'] is Map<String, dynamic>?
          ? ProjectConfigModel.fromMap(
              map['projectConfig'] as Map<String, dynamic>)
          : null,
      screens: map['screens'] != null && map['screens'] is List
          ? List<MitraScreen>.from(
              (map['screens'] as List<dynamic>? ?? []).map<MitraScreen?>(
                (x) => MitraScreen.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      workSpaceConfig: map['workSpaceConfig'] != null &&
              map['workSpaceConfig'] is Map<String, dynamic>?
          ? WorkspaceConfigModel.fromMap(
              map['workSpaceConfig'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String?, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(accessType: $accessType, collaboratorProfile: $collaboratorProfile, id: $id, name: $name, projectConfig: $projectConfig, screens: $screens, workSpaceConfig: $workSpaceConfig, accordionListSelected: $accordionListSelected,)';
  }
}
