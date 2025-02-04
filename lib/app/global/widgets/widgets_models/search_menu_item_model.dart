// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:open_mitra_mobile/app/data/model/projects_models/activated_screen.dart';

enum SearchMenuEnum {
  all,
  project,
  screen,
}

class SearchMenuItem {
  int? projectId;
  int? screenId;
  String? icon;
  String? title;
  String? subTitle;
  String? hexColor;
  SearchMenuEnum? itemType;
  ActivatedScreenModel? screen;
  int? workspaceId;
  String? logoImg;
  String? primaryColor;

  SearchMenuItem({
    this.projectId,
    this.icon,
    this.title,
    this.subTitle,
    this.hexColor,
    this.itemType,
    this.screen,
    this.screenId,
    this.workspaceId,
    this.logoImg,
    this.primaryColor
  });


  @override
  String toString() {
    return 'SearchMenuItem(projectId: $projectId, screenId: $screenId, icon: $icon, title: $title, subTitle: $subTitle, hexColor: $hexColor, itemType: $itemType, screen: $screen, workspaceId: $workspaceId, logoImg: $logoImg, primaryColor: $primaryColor)';
  }
}
