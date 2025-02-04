import 'package:open_mitra_mobile/app/data/model/projects_models/filter_dimension_contents_model.dart';

FilterBarSelectionsModel filterBarSelectionsModelFromJson(str) =>
    FilterBarSelectionsModel.fromJson(str);

//NOTE: Dados dos filtros filhos com dimensões.
class FilterBarSelectionsModel {
  int? id;
  String? dimensionName;
  bool? persisted;
  bool? singleSelection;
  String? startDay;
  String? endDay;
  List<FilterDimensionContentsModel>? dimensionContents;
  bool isAllSelected; //NOTE: Referencia do selecionar todos.
  int selectedQuantity; //NOTE: Referencia da quantidade selecionada.
  List<FilterDimensionContentsModel>?
      tempSearchDimensionContents; //NOTE: Usado no search.
  bool listOfDimensionIsOrdered;

  FilterBarSelectionsModel({
    this.dimensionName,
    this.persisted,
    this.singleSelection,
    this.startDay,
    this.endDay,
    this.dimensionContents,
    this.id,
    this.isAllSelected = false,
    this.selectedQuantity = 0,
    this.tempSearchDimensionContents,
    this.listOfDimensionIsOrdered = false,
  });

  factory FilterBarSelectionsModel.fromJson(Map<String, dynamic> json) =>
      FilterBarSelectionsModel(
        id: json["id"],
        dimensionName: json["dimensionName"],
        persisted: json["persisted"],
        singleSelection: json["singleSelection"],
        startDay: json["startDay"],
        endDay: json["endDay"],
        dimensionContents: (json["dimensionContents"] as List<dynamic>?)
            ?.map((e) => FilterDimensionContentsModel.fromJson(
                e as Map<String, dynamic>))
            .toList(),
        tempSearchDimensionContents:
            (json["dimensionContents"] as List<dynamic>?)
                ?.map((e) => FilterDimensionContentsModel.fromJson(
                    e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        "dimensionName": dimensionName,
        "id": id,
        "persisted": persisted,
        "singleSelection": singleSelection,
        "startDay": startDay,
        "endDay": endDay,
        "dimensionContents": dimensionContents?.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return 'FilterBarSelectionsModel(id: $id, dimensionName: $dimensionName, persisted: $persisted, singleSelection: $singleSelection,startDay: $startDay,endDay: $endDay, dimensionContents: $dimensionContents, isAllSelected: $isAllSelected, selectedQuantity: $selectedQuantity, tempSearchDimensionContents: $tempSearchDimensionContents, listOfDimensionIsOrdered: $listOfDimensionIsOrdered)';
  }
}
