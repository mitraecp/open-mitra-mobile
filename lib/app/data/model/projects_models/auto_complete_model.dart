import 'package:open_mitra_mobile/app/data/model/projects_models/relation_ship_dimension_model.dart';

class AutoCompleteModel {
  int? componentId;
  Map<String, dynamic>? relationShipDimension;
  List<RelationShipDimension>? childrenRelationShipDimension;
  List<RelationShipDimension>? tempForSortchildrenRelationShipDimension;

  AutoCompleteModel({
    this.componentId,
    this.relationShipDimension,
    this.childrenRelationShipDimension,
    this.tempForSortchildrenRelationShipDimension,
  });

  factory AutoCompleteModel.fromJson(Map<String, dynamic> json) {
    return AutoCompleteModel(
      componentId: json["id"],
      relationShipDimension: json["relationShipDimension"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = componentId;
    data['relationShipDimension'] = relationShipDimension;
    return data;
  }
}
