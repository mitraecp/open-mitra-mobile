// To parse this JSON data, do
//
//     final modulesModel = modulesModelFromJson(jsonString);

import 'dart:convert';

import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';

List<ModuleModel> modulesModelFromJson(str) =>
    List<ModuleModel>.from(str.map((x) => ModuleModel.fromJson(x)));

String modulesModelToJson(List<ModuleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleModel {
  int id;
  String name;
  int homeScreenId;
  int? mobileHomeScreenId;
  List<ScreenModel>? listOfScreens;

  ModuleModel({
    required this.id,
    required this.name,
    required this.homeScreenId,
    this.mobileHomeScreenId,
    this.listOfScreens,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
        id: json["id"],
        name: json["name"],
        homeScreenId: json["homeScreenId"],
        mobileHomeScreenId: json["mobileHomeScreenId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "homeScreenId": homeScreenId,
        "mobileHomeScreenId": mobileHomeScreenId
      };
}
