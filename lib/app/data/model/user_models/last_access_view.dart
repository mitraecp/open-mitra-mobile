// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LastAccessView {
  int? projectId;
  int? workspaceId;

  LastAccessView({
    this.projectId,
    this.workspaceId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectId': projectId,
      'workspaceId': workspaceId,
    };
  }

  factory LastAccessView.fromMap(Map<String, dynamic> map) {
    return LastAccessView(
      projectId: map['projectId'] != null ? map['projectId'] as int : null,
      workspaceId: map['workspaceId'] != null ? map['workspaceId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastAccessView.fromJson(String source) => LastAccessView.fromMap(json.decode(source) as Map<String, dynamic>);


  @override
  String toString() => 'LastAccessView(projectId: $projectId, workspaceId: $workspaceId)';
}
