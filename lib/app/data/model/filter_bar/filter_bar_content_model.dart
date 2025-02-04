// To parse this JSON data, do
//
//     final modulesModel = modulesModelFromJson(jsonString);

import 'dart:convert';

List<FilterBarContentModel> modulesModelFromJson(str) =>
    List<FilterBarContentModel>.from(
        str.map((x) => FilterBarContentModel.fromJson(x)));

String modulesModelToJson(List<FilterBarContentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//NOTE: Esse é o filtro filho, porem neste não tem dados das dimensões dele. (ex: somente mÊs)

class FilterBarContentModel {
  int? id;
  String? alias;
  int? dimensionId;
  String? name;
  int? order;
  bool? singleSelection;

  FilterBarContentModel({
    this.id,
    this.alias,
    this.dimensionId,
    this.name,
    this.order,
    this.singleSelection,
  });

  factory FilterBarContentModel.fromJson(Map<String, dynamic> json) =>
      FilterBarContentModel(
        id: json["id"],
        alias: json["alias"],
        dimensionId: json["dimensionId"],
        name: json["name"],
        order: json["order"],
        singleSelection: json["singleSelection"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alias": alias,
        "dimensionId": dimensionId,
        "name": name,
        "order": order,
        "singleSelection": singleSelection
      };
}
