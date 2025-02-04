// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MitraScreen {
  int id;
  int? baseId;
  String? baseName;
  int? workspaceId;
  String? workspaceName;
  String name;
  String accessType;
  String? spaceType;
  bool? opened;
  int? projectId;
  String? projectName;

  MitraScreen({
    required this.id,
    this.baseId,
    this.baseName,
    this.workspaceId,
    this.workspaceName,
    required this.name,
    required this.accessType,
    this.spaceType,
    this.opened,
    this.projectId,
    this.projectName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'baseId': baseId,
      'baseName': baseName,
      'workspaceId': workspaceId,
      'workspaceName': workspaceName,
      'name': name,
      'accessType': accessType,
      'spaceType': spaceType,
      'opened': opened,
      'projectId': projectId,
      'projectName': projectName,
    };
  }

  factory MitraScreen.fromMap(Map<String, dynamic> map) {
    return MitraScreen(
      id: map['id'] as int,
      baseId: map['baseId'] != null ? map['baseId'] as int : null,
      baseName: map['baseName'] != null ? map['baseName'] as String : null,
      workspaceId: map['workspaceId'] != null ? map['workspaceId'] as int : null,
      workspaceName: map['workspaceName'] != null ? map['workspaceName'] as String : null,
      name: map['name'] as String,
      accessType: map['accessType'] as String,
      spaceType: map['spaceType'] != null ? map['spaceType'] as String : null,
      opened: map['opened'] != null ? map['opened'] as bool : null,
      projectId: map['projectId'] != null ? map['projectId'] as int : null,
      projectName: map['projectName'] != null ? map['projectName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MitraScreen.fromJson(String source) => MitraScreen.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MitraScreen(id: $id, baseId: $baseId, baseName: $baseName, workspaceId: $workspaceId, workspaceName: $workspaceName, name: $name, accessType: $accessType, spaceType: $spaceType, opened: $opened, projectId: $projectId, projectName: $projectName)';
  }

  MitraScreen copyWith({
    int? id,
    int? baseId,
    String? baseName,
    int? workspaceId,
    String? workspaceName,
    String? name,
    String? accessType,
    String? spaceType,
    bool? opened,
    int? projectId,
    String? projectName,
  }) {
    return MitraScreen(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      baseName: baseName ?? this.baseName,
      workspaceId: workspaceId ?? this.workspaceId,
      workspaceName: workspaceName ?? this.workspaceName,
      name: name ?? this.name,
      accessType: accessType ?? this.accessType,
      spaceType: spaceType ?? this.spaceType,
      opened: opened ?? this.opened,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
    );
  }

  @override
  bool operator ==(covariant MitraScreen other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.baseId == baseId &&
      other.baseName == baseName &&
      other.workspaceId == workspaceId &&
      other.workspaceName == workspaceName &&
      other.name == name &&
      other.accessType == accessType &&
      other.spaceType == spaceType &&
      other.opened == opened &&
      other.projectId == projectId &&
      other.projectName == projectName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      baseId.hashCode ^
      baseName.hashCode ^
      workspaceId.hashCode ^
      workspaceName.hashCode ^
      name.hashCode ^
      accessType.hashCode ^
      spaceType.hashCode ^
      opened.hashCode ^
      projectId.hashCode ^
      projectName.hashCode;
  }
}
