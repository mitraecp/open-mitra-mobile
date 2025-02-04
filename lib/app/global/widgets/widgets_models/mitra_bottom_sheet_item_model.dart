import 'package:flutter/material.dart';

class MitraBottomSheetItemModel {
  Widget itemIcon;
  String itemName;
  bool isSelected;
  Color? itemIconBgColor;
  int? itemId;

  MitraBottomSheetItemModel({
    required this.itemIcon,
    required this.itemName,
    required this.isSelected,
    this.itemIconBgColor,
    this.itemId,
  });

  @override
  String toString() =>
      'MitraBottomSheetItemModel(itemIcon: $itemIcon, itemName: $itemName, isSelected: $isSelected, itemId: $itemId)';

  @override
  bool operator ==(covariant MitraBottomSheetItemModel other) {
    if (identical(this, other)) return true;

    return other.itemIcon == itemIcon &&
        other.itemName == itemName &&
        other.isSelected == isSelected &&
        other.itemId == itemId;
  }

  @override
  int get hashCode =>
      itemIcon.hashCode ^
      itemName.hashCode ^
      isSelected.hashCode ^
      itemId.hashCode;
}
