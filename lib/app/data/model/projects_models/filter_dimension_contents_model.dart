FilterDimensionContentsModel filterDimensionContentsModelFromJson(str) =>
    FilterDimensionContentsModel.fromJson(str);

//NOTE: Dimensões do filtro filho.
class FilterDimensionContentsModel {
  String? descr;
  int? dimensionId;
  bool? isSelected;
  String? value;
  bool
      tempSelected; // NOTE: Usado dentro dos dialogs como temporarios antes do usuario clicar em adicionar ou cancelar.

  FilterDimensionContentsModel({
    this.descr,
    this.dimensionId,
    this.isSelected,
    this.value,
    this.tempSelected = false,
  });

  @override
  bool operator ==(covariant FilterDimensionContentsModel other) {
    if (identical(this, other)) return true;

    return other.descr == descr &&
        other.dimensionId == dimensionId &&
        other.isSelected == isSelected &&
        other.value == value &&
        other.tempSelected == tempSelected;
  }

  @override
  int get hashCode {
    return descr.hashCode ^
        dimensionId.hashCode ^
        isSelected.hashCode ^
        value.hashCode ^
        tempSelected.hashCode;
  }

  factory FilterDimensionContentsModel.fromJson(Map<String, dynamic> json) =>
      FilterDimensionContentsModel(
        descr: json["descr"],
        dimensionId: json["dimensionId"],
        isSelected: json["isSelected"],
        value: json["value"],
        tempSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "descr": descr,
        "dimensionId": dimensionId,
        "isSelected": isSelected,
        "value": value
      };
      
  @override
  String toString() {
    return 'FilterDimensionContentsModel(descr: $descr, dimensionId: $dimensionId, isSelected: $isSelected, value: $value, tempSelected: $tempSelected)';
  }
}
