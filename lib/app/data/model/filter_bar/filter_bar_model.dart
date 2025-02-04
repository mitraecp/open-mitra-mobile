import 'package:open_mitra_mobile/app/data/model/filter_bar/filter_bar_content_model.dart';

FilterBarModel filterBarModelFromJson(str) => FilterBarModel.fromJson(str);

//NOTE: Esse é o filtro pai, que guarda todas os filtros dentro dele.(ex: mes, dia, empresa)

class FilterBarModel {
  int? id;
  String? name;
  int? screenComponentId;
  List<FilterBarContentModel>? filterBarContent;

  FilterBarModel({
    this.id,
    this.name,
    this.screenComponentId,
    this.filterBarContent,
  });

  factory FilterBarModel.fromJson(Map<String, dynamic> json) => FilterBarModel(
        id: json["id"],
        name: json["name"],
        screenComponentId: json["screenComponentId"],
        filterBarContent: (json["filterBarContent"] as List<dynamic>?)
            ?.map((e) =>
                FilterBarContentModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "screenComponentId": screenComponentId,
        "filterBarContent": filterBarContent?.map((e) => e.toJson()).toList(),
      };
}
