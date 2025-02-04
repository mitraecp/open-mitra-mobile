import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/controllers/project_controller.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/repository/menu_repository/interface/menu_page_repository_interface';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_icon_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';


class MenuPageController extends GetxController {
  final WorkspaceController workspaceController = Get.find();
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final ProjectController projectController = Get.find();

  final IMenuPageRepository menuRepository;

  MenuPageController({required this.menuRepository});

  RxBool loading = false.obs, sendingEmail = false.obs;
  RxBool isEditingReportError = false.obs;
  RxBool isToShowAppBarOnTopContainer = false.obs;

  TextEditingController emailFromReportError = TextEditingController();
  TextEditingController textReportError = TextEditingController();
  TextEditingController searchTextController = TextEditingController();

  RxList<MitraBottomSheetItemModel> workspaceList =
      RxList<MitraBottomSheetItemModel>([]);

  @override
  onReady() {
    super.onReady();
    // emailFromReportError.addListener(_verifySendEmail);
    textReportError.addListener(_verifySendEmail);
    emailFromReportError.text = userController.loggedUser.value.email ?? '';
    projectController.unSelectAccordionProjectsAndFolder();

    int projectStoragedId =
        (GetStorage().read(StoreTypes.projectStoraged) ?? -1).toInt();
    if (projectStoragedId != -1) {
      homeController.showProjectsInMenuPage.value = true;
    } else {
      homeController.showProjectsInMenuPage.value = false;
    }
  }

  _verifySendEmail() {
    textReportError.text != '' ? isEditingReportError.value = true : null;
  }

  Future<bool> sentReportError() async {
    sendingEmail.value = true;
    isEditingReportError.value = false;
    if (await menuRepository.sendReportError(
      loggedUser: userController.loggedUser.value,
      message: textReportError.text,
    )) {
      cleanControllers();
      return true;
    } else {
      return false;
    }
  }

  void cleanControllers() {
    // emailFromReportError.clear();
    textReportError.clear();
    isEditingReportError.value = false;
  }

  getListOfMitraBottomSheetItem() {
    final List<MitraBottomSheetItemModel> tempList =
        <MitraBottomSheetItemModel>[];
    for (var i = 0;
        i < workspaceController.listOfUserWorkspaces.value.length;
        i++) {
      final currentItem = workspaceController.listOfUserWorkspaces.value[i];
      MitraBottomSheetItemModel tempItem = MitraBottomSheetItemModel(
          isSelected: currentItem.name ==
              workspaceController.selectWorkspace.value.name,
          itemIcon: MitraCardIconWidget(
            cardIcon: 'initials',
            hexColor: '#7839EE',
            cardInitials: currentItem.name,
          ),
          itemName: currentItem.name,
          itemId: currentItem.id);
      tempList.add(tempItem);
    }

    workspaceList.value = tempList;
    sortList();
  }

  sortList() {
    workspaceList.sort((a, b) {
      return a.itemName.toLowerCase().compareTo(b.itemName
          .toLowerCase()); // Comparação padrão quando ambos não são nulos
    });
  }
}
