// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class DetailBuilderButtonModel {
  int? actionId;
  String backgroundColor;
  int? blockCubeId;
  bool closeAfterExecute;
  bool closeAllModals;
  String? confirmationCancel;
  String? confirmationMsg;
  String? confirmationAccept;
  int detailBuilderId;
  int? detailId;
  String? executionType;
  bool? floatScreen;
  bool hasConfirmationMsg;
  String? icon;
  int id;
  int? moduleId;
  int? screenHeight;
  int? screenId;
  String screenPosition;
  int? screenWidth;
  int? targetFlapId;
  String textColor;
  String title;
  String tooltip;
  DetailBuilderButtonModel({
    this.actionId,
    required this.backgroundColor,
    this.blockCubeId,
    required this.closeAfterExecute,
    required this.closeAllModals,
    this.confirmationCancel,
    this.confirmationMsg,
    this.confirmationAccept,
    required this.detailBuilderId,
    this.detailId,
    this.executionType,
    this.floatScreen,
    required this.hasConfirmationMsg,
    this.icon,
    required this.id,
    this.moduleId,
    this.screenHeight,
    this.screenId,
    required this.screenPosition,
    this.screenWidth,
    this.targetFlapId,
    required this.textColor,
    required this.title,
    required this.tooltip,
  });

  DetailBuilderButtonModel copyWith({
    int? actionId,
    String? backgroundColor,
    int? blockCubeId,
    bool? closeAfterExecute,
    bool? closeAllModals,
    String? confirmationCancel,
    String? confirmationMsg,
    String? confirmationAccept,
    int? detailBuilderId,
    int? detailId,
    String? executionType,
    bool? floatScreen,
    bool? hasConfirmationMsg,
    String? icon,
    int? id,
    int? moduleId,
    int? screenHeight,
    int? screenId,
    String? screenPosition,
    int? screenWidth,
    int? targetFlapId,
    String? textColor,
    String? title,
    String? tooltip,
  }) {
    return DetailBuilderButtonModel(
      actionId: actionId ?? this.actionId,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      blockCubeId: blockCubeId ?? this.blockCubeId,
      closeAfterExecute: closeAfterExecute ?? this.closeAfterExecute,
      closeAllModals: closeAllModals ?? this.closeAllModals,
      confirmationCancel: confirmationCancel ?? this.confirmationCancel,
      confirmationMsg: confirmationMsg ?? this.confirmationMsg,
      confirmationAccept: confirmationAccept ?? this.confirmationAccept,
      detailBuilderId: detailBuilderId ?? this.detailBuilderId,
      detailId: detailId ?? this.detailId,
      executionType: executionType ?? this.executionType,
      floatScreen: floatScreen ?? this.floatScreen,
      hasConfirmationMsg: hasConfirmationMsg ?? this.hasConfirmationMsg,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      screenHeight: screenHeight ?? this.screenHeight,
      screenId: screenId ?? this.screenId,
      screenPosition: screenPosition ?? this.screenPosition,
      screenWidth: screenWidth ?? this.screenWidth,
      targetFlapId: targetFlapId ?? this.targetFlapId,
      textColor: textColor ?? this.textColor,
      title: title ?? this.title,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'actionId': actionId,
      'backgroundColor': backgroundColor,
      'blockCubeId': blockCubeId,
      'closeAfterExecute': closeAfterExecute,
      'closeAllModals': closeAllModals,
      'confirmationCancel': confirmationCancel,
      'confirmationMsg': confirmationMsg,
      'confirmationAccept': confirmationAccept,
      'detailBuilderId': detailBuilderId,
      'detailId': detailId,
      'executionType': executionType,
      'floatScreen': floatScreen,
      'hasConfirmationMsg': hasConfirmationMsg,
      'icon': icon,
      'id': id,
      'moduleId': moduleId,
      'screenHeight': screenHeight,
      'screenId': screenId,
      'screenPosition': screenPosition,
      'screenWidth': screenWidth,
      'targetFlapId': targetFlapId,
      'textColor': textColor,
      'title': title,
      'tooltip': tooltip,
    };
  }

  factory DetailBuilderButtonModel.fromMap(Map<String, dynamic> map) {
    return DetailBuilderButtonModel(
      actionId: map['actionId'] != null ? map['actionId'] as int : null,
      backgroundColor: map['backgroundColor'] as String,
      blockCubeId: map['blockCubeId'] != null ? map['blockCubeId'] as int : null,
      closeAfterExecute: map['closeAfterExecute'] as bool,
      closeAllModals: map['closeAllModals'] as bool,
      confirmationCancel: map['confirmationCancel'] != null ? map['confirmationCancel'] as String : null,
      confirmationMsg: map['confirmationMsg'] != null ? map['confirmationMsg'] as String : null,
      confirmationAccept: map['confirmationAccept'] != null ? map['confirmationAccept'] as String : null,
      detailBuilderId: map['detailBuilderId'] as int,
      detailId: map['detailId'] != null ? map['detailId'] as int : null,
      executionType: map['executionType'] != null ? map['executionType'] as String : null,
      floatScreen: map['floatScreen'] != null ? map['floatScreen'] as bool : null,
      hasConfirmationMsg: map['hasConfirmationMsg'] as bool,
      icon: map['icon'] != null ? map['icon'] as String : null,
      id: map['id'] as int,
      moduleId: map['moduleId'] != null ? map['moduleId'] as int : null,
      screenHeight: map['screenHeight'] != null ? map['screenHeight'] as int : null,
      screenId: map['screenId'] != null ? map['screenId'] as int : null,
      screenPosition: map['screenPosition'] as String,
      screenWidth: map['screenWidth'] != null ? map['screenWidth'] as int : null,
      targetFlapId: map['targetFlapId'] != null ? map['targetFlapId'] as int : null,
      textColor: map['textColor'] as String,
      title: map['title'] as String,
      tooltip: map['tooltip'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailBuilderButtonModel.fromJson(String source) => DetailBuilderButtonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailBuilderButtonModel(actionId: $actionId, backgroundColor: $backgroundColor, blockCubeId: $blockCubeId, closeAfterExecute: $closeAfterExecute, closeAllModals: $closeAllModals, confirmationCancel: $confirmationCancel, confirmationMsg: $confirmationMsg, confirmationAccept: $confirmationAccept, detailBuilderId: $detailBuilderId, detailId: $detailId, executionType: $executionType, floatScreen: $floatScreen, hasConfirmationMsg: $hasConfirmationMsg, icon: $icon, id: $id, moduleId: $moduleId, screenHeight: $screenHeight, screenId: $screenId, screenPosition: $screenPosition, screenWidth: $screenWidth, targetFlapId: $targetFlapId, textColor: $textColor, title: $title, tooltip: $tooltip)';
  }

  @override
  bool operator ==(covariant DetailBuilderButtonModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.actionId == actionId &&
      other.backgroundColor == backgroundColor &&
      other.blockCubeId == blockCubeId &&
      other.closeAfterExecute == closeAfterExecute &&
      other.closeAllModals == closeAllModals &&
      other.confirmationCancel == confirmationCancel &&
      other.confirmationMsg == confirmationMsg &&
      other.confirmationAccept == confirmationAccept &&
      other.detailBuilderId == detailBuilderId &&
      other.detailId == detailId &&
      other.executionType == executionType &&
      other.floatScreen == floatScreen &&
      other.hasConfirmationMsg == hasConfirmationMsg &&
      other.icon == icon &&
      other.id == id &&
      other.moduleId == moduleId &&
      other.screenHeight == screenHeight &&
      other.screenId == screenId &&
      other.screenPosition == screenPosition &&
      other.screenWidth == screenWidth &&
      other.targetFlapId == targetFlapId &&
      other.textColor == textColor &&
      other.title == title &&
      other.tooltip == tooltip;
  }

  @override
  int get hashCode {
    return actionId.hashCode ^
      backgroundColor.hashCode ^
      blockCubeId.hashCode ^
      closeAfterExecute.hashCode ^
      closeAllModals.hashCode ^
      confirmationCancel.hashCode ^
      confirmationMsg.hashCode ^
      confirmationAccept.hashCode ^
      detailBuilderId.hashCode ^
      detailId.hashCode ^
      executionType.hashCode ^
      floatScreen.hashCode ^
      hasConfirmationMsg.hashCode ^
      icon.hashCode ^
      id.hashCode ^
      moduleId.hashCode ^
      screenHeight.hashCode ^
      screenId.hashCode ^
      screenPosition.hashCode ^
      screenWidth.hashCode ^
      targetFlapId.hashCode ^
      textColor.hashCode ^
      title.hashCode ^
      tooltip.hashCode;
  }
}
