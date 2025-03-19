import 'package:flutter/material.dart';

class MitraBottomSheetItemModel {
  Widget itemIcon;
  String itemName;
  bool isSelected;
  Color? itemIconBgColor;
  int? itemId;
  bool? disabled;

  MitraBottomSheetItemModel({
    required this.itemIcon,
    required this.itemName,
    required this.isSelected,
    this.itemIconBgColor,
    this.itemId,
    this.disabled = false,
  });

  @override
  String toString() =>
      'MitraBottomSheetItemModel(itemIcon: $itemIcon, itemName: $itemName, isSelected: $isSelected, itemId: $itemId, disabled: $disabled)';

  @override
  bool operator ==(covariant MitraBottomSheetItemModel other) {
    if (identical(this, other)) return true;

    return other.itemIcon == itemIcon &&
        other.itemName == itemName &&
        other.isSelected == isSelected &&
        other.itemId == itemId &&
        other.disabled == disabled;
  }

  @override
  int get hashCode =>
      itemIcon.hashCode ^
      itemName.hashCode ^
      isSelected.hashCode ^
      itemId.hashCode ^
      disabled.hashCode;
}
