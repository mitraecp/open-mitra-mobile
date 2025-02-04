class SelectedFilterTempModel {
  int? selectedDimensionId;
  List<String>? selectedValue;
  int selectedQuantity;

  SelectedFilterTempModel({
    this.selectedDimensionId,
    this.selectedValue,
    this.selectedQuantity = 0,
  });
}