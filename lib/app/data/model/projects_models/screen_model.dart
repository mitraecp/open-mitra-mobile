import 'dart:convert';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/auto_complete_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

List<ScreenModel> screenModelFromJson(str) =>
    List<ScreenModel>.from(str.map((x) => ScreenModel.fromJson(x)));

String screenModelToJson(List<ScreenModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScreenModel {
  int? id;
  String? name;
  String? alias;
  bool? showIcon;
  String? icon;
  int? filterBarId;
  RxBool haveValueSelected = false.obs;
  RxBool loadingFilter = false.obs;
  //NOTE: Isso são os filtros filhos.
  List<FilterBarSelectionsModel>? filterBarSelectionsDimensions;
  RxBool isToHidePage = true.obs;
  String? webviewUrl;
  late WebViewController? webListController;
  List<AutoCompleteModel>? autoCompleteModel;

  ScreenModel({
    this.id,
    this.name,
    this.alias,
    this.showIcon,
    this.icon,
    this.filterBarId,
    this.filterBarSelectionsDimensions,
    this.webviewUrl,
    this.webListController,
    this.autoCompleteModel,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) => ScreenModel(
        id: json["id"],
        name: json["name"],
        alias: json["alias"],
        showIcon: json["showIcon"],
        icon: json["icon"],
        filterBarId: json["filterBarId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alias": alias,
        "showIcon": showIcon,
        "icon": icon,
        "filterBarId": icon,
      };

  @override
  String toString() {
    return 'ScreenModel(id: $id, name: $name, alias: $alias, showIcon: $showIcon, icon: $icon, filterBarId: $filterBarId, haveValueSelected: $haveValueSelected, loadingFilter: $loadingFilter, filterBarSelectionsDimensions: $filterBarSelectionsDimensions, isToHidePage: $isToHidePage, webviewUrl: $webviewUrl, webListController: $webListController, autoCompleteModel: $autoCompleteModel)';
  }
}
