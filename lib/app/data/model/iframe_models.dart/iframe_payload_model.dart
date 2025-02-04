// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IframePayloadModel {
  String messageType;
  dynamic messageBody;

  IframePayloadModel({
    required this.messageType,
    required this.messageBody,
  });

  IframePayloadModel copyWith({
    String? messageType,
    dynamic messageBody,
  }) {
    return IframePayloadModel(
      messageType: messageType ?? this.messageType,
      messageBody: messageBody ?? this.messageBody,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageType': messageType,
      'messageBody': messageBody,
    };
  }

  factory IframePayloadModel.fromMap(Map<String, dynamic> map) {
    return IframePayloadModel(
      messageType: map['messageType'] as String,
      messageBody: map['messageBody'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory IframePayloadModel.fromJson(String source) =>
      IframePayloadModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IframePayloadModel(messageType: $messageType, messageBody: $messageBody)';

  @override
  bool operator ==(covariant IframePayloadModel other) {
    if (identical(this, other)) return true;

    return other.messageType == messageType && other.messageBody == messageBody;
  }

  @override
  int get hashCode => messageType.hashCode ^ messageBody.hashCode;
}
