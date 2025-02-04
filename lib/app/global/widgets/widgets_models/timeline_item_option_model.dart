// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TimelineItemOptionModel {
  List<dynamic> selectedTimelineItem;
  int selectedTimelineIndex;
  TimelineItemOptionModel({
    required this.selectedTimelineItem,
    required this.selectedTimelineIndex,
  });

  TimelineItemOptionModel copyWith({
    List<dynamic>? selectedTimelineItem,
    int? selectedTimelineIndex,
  }) {
    return TimelineItemOptionModel(
      selectedTimelineItem: selectedTimelineItem ?? this.selectedTimelineItem,
      selectedTimelineIndex:
          selectedTimelineIndex ?? this.selectedTimelineIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedTimelineItem': selectedTimelineItem,
      'selectedTimelineIndex': selectedTimelineIndex,
    };
  }

  factory TimelineItemOptionModel.fromMap(Map<String, dynamic> map) {
    return TimelineItemOptionModel(
      selectedTimelineItem:
          List<dynamic>.from((map['selectedTimelineItem'] as List<dynamic>)),
      selectedTimelineIndex: map['selectedTimelineIndex'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimelineItemOptionModel.fromJson(String source) =>
      TimelineItemOptionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TimelineItemOptionModel(selectedTimelineItem: $selectedTimelineItem, selectedTimelineIndex: $selectedTimelineIndex)';

  @override
  bool operator ==(covariant TimelineItemOptionModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.selectedTimelineItem, selectedTimelineItem) &&
        other.selectedTimelineIndex == selectedTimelineIndex;
  }

  @override
  int get hashCode =>
      selectedTimelineItem.hashCode ^ selectedTimelineIndex.hashCode;
}
