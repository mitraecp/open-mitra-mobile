import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final LoginController loginController = Get.find();
  final WorkspaceController workspaceController = Get.find();

  TextEditingController nameController = TextEditingController();

  RxBool isToShowAppBarOnTopContainer = false.obs,
      isToDisabledUserChangeName = false.obs;

  Timer? _changeUserNametimer;
  int _timerCountOfChangeUserName = 0;

  @override
  void onInit() {
    nameController.text = userController.loggedUser.value.name ?? '';
    nameController.addListener(handleChangeNameController);
    verifyIsToDisabledUserChangeName();
    super.onInit();
  }

  verifyIsToDisabledUserChangeName() {
    isToDisabledUserChangeName.value =
        userController.loggedUser.value.userOrigin != 'internal_user';
  }

  handleChangeNameController() {
    if (nameController.text != userController.loggedUser.value.name) {
      _timerCountOfChangeUserName = 0;
      _changeUserNametimer?.cancel(); // Cancela o timer atual, se existir
      _changeUserNametimer =
          Timer.periodic(const Duration(milliseconds: 1), (timer) {
        _timerCountOfChangeUserName++;

        if (_timerCountOfChangeUserName == 2000) {
          _changeUserNametimer
              ?.cancel(); // Cancela o timer quando atingir o tempo
          userController.changeLoggedUserName(nameController.text);
        }
      });
    }
  }

  changeLanguage(int index) {
    var tempList = languageLocalesOptions();
    if (tempList[index].itemName == 'brazilian_portuguese'.tr) {
      Get.updateLocale(const Locale('pt'));
      userController.changeLoggedUserLanguage('pt-BR');
    } else {
      Get.updateLocale(const Locale('en'));
      userController.changeLoggedUserLanguage('en-US');
    }
  }

  deleteUserAccount() {
    print('delete');
  }

  switchApps() {
    workspaceController.tempUserTokenByWorkspace.value =
        GetStorage().read(StoreTypes.userToken);

    GetStorage().remove(StoreTypes.userToken);
    Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
    
  }

  logout() async {
    StoreTypes.disposeAllStore();
    userController.disposeUserController();
    workspaceController.disposeWorkspaceController();
    homeController.disposeHomeController();
    if (userController.loggedUser.value.userOrigin == 'google') {
      await loginController.logoutGoogle();
    }
    // Get.offAllNamed(AppPages.INTRO_SCREEN);
    Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
  }

  List<MitraBottomSheetItemModel> languageLocalesOptions() {
    List<MitraBottomSheetItemModel> tempList = [];
    print(Get.locale);
    MitraBottomSheetItemModel ptBrItem = MitraBottomSheetItemModel(
      isSelected: Get.locale == const Locale('pt'),
      itemIcon: ClipOval(
        child: SvgPicture.asset(
          'assets/svg/br_icon.svg',
          height: 32,
          width: 32,
        ),
      ),
      itemName: 'brazilian_portuguese'.tr,
    );

    MitraBottomSheetItemModel enUsItem = MitraBottomSheetItemModel(
      isSelected: Get.locale == const Locale('en'),
      itemIcon: ClipOval(
        child: SvgPicture.asset(
          'assets/svg/us_icon.svg',
          height: 32,
          width: 32,
        ),
      ),
      itemName: 'english'.tr,
    );

    tempList.add(ptBrItem);
    tempList.add(enUsItem);

    return tempList;
  }
}
