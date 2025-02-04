// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:open_mitra_mobile/app/data/model/projects_models/mitra_screen.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_config_model.dart';

class WorkspaceModel {
  int id;
  String name;
  List<LoggedUser>? collaboratorProfile;
  String accessType;
  List<ProjectModel> projects;
  List<ProjectModel>? aiProjects;
  List<MitraScreen>? screens;
  WorkspaceConfigModel? workspaceConfig;

  WorkspaceModel({
    required this.accessType,
    this.collaboratorProfile,
    required this.id,
    required this.name,
    required this.projects,
    this.aiProjects,
    this.screens,
    this.workspaceConfig,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessType': accessType,
      'collaboratorProfile':
          collaboratorProfile?.map((x) => x.toMap()).toList(),
      'id': id,
      'name': name,
      'projects': projects.map((x) => x.toMap()).toList(),
      'screens': screens?.map((x) => x.toMap()).toList(),
      'workspaceConfig': workspaceConfig?.toMap(),
    };
  }

  factory WorkspaceModel.fromMap(Map<String?, dynamic> map) {
    return WorkspaceModel(
      accessType: map['accessType'] as String,
      collaboratorProfile: map['collaboratorProfile'] != null &&
              map['collaboratorProfile'] is List
          ? List<LoggedUser>.from(
              (map['collaboratorProfile'] as List<dynamic>? ?? [])
                  .map<LoggedUser?>(
                (x) => LoggedUser.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      id: map['id'] as int,
      name: map['name'] as String,
      projects: map['projects'] != null && map['projects'] is List
          ? List<ProjectModel>.from(
              (map['projects'] as List<dynamic>? ?? []).map<ProjectModel>(
                (x) => ProjectModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      screens: map['screens'] != null && map['screens'] is List
          ? List<MitraScreen>.from(
              (map['screens'] as List<dynamic>? ?? []).map<MitraScreen?>(
                (x) => MitraScreen.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      workspaceConfig: map['workspaceConfig'] != null
          ? WorkspaceConfigModel.fromMap(
              map['workspaceConfig'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkspaceModel.fromJson(String source) =>
      WorkspaceModel.fromMap(json.decode(source) as Map<String?, dynamic>);

  @override
  String toString() {
    return 'WorkspaceModel(id: $id, name: $name, collaboratorProfile: $collaboratorProfile, accessType: $accessType, projects: $projects, screens: $screens, workspaceConfig: $workspaceConfig)';
  }
}
