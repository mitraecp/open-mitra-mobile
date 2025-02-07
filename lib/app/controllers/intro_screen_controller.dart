import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/webview_store_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/model/base_url_mitra_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/last_access_view.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/interface/project_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_icon_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/helpers/github_services.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IntroScreenController extends GetxController {
  final WorkspaceController workspaceController = Get.find();
  final UserController userController = Get.find();
  final WebViewStore webViewStore = Get.find();
  final IProjectRepository projectRepository = Get.find();

  Rx<LastAccessView> lastAccessView = Rx(LastAccessView());
  RxInt clickForDevMode = 0.obs;

  RxBool isToShowAllDescription = false.obs,
      loadingAppPublishDataPage = false.obs;
  RxList<String> appPublishImgGallery = <String>[].obs;

  late YoutubePlayerController youtubePlayerController;

  @override
  void onInit() async {
    getAppVersion();
    // handleDynamicLink();
    await setBaseFrontUrl();
    super.onInit();

    if (!webViewStore.webViewCreated) {
      webViewStore.initWebViewController();
      verifyIfWebViewFinishLoading();
    } else {
      await hadLoggedUser();
    }
  }

  Future<void> getAppVersion() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      globalAppVersion = packageInfo.version;
    });
  }

  setBaseFrontUrl() async {
    await GithubService().getIsToUseQAUrl().then((Map<String, dynamic> value) {

      currentBaseUrlLink.value =
          GetStorage().read(StoreTypes.currentBaseUrlLink) ??
              value['currentBaseUrl'];
      currentBaseUrlNameUrl.value =
          GetStorage().read(StoreTypes.currentBaseNameUrlLink) ??
              value['currentBaseNameUrl'];

      // Obtenha a lista de URLs base do mapa
      List<dynamic> listOfBaseUrlJson = value['listOfBaseUrl'] as List<dynamic>;

      // Crie a lista de objetos BaseUrlMitraModel
      List<BaseUrlMitraModel> listOfBaseUrl =
          listOfBaseUrlJson.map((baseUrlJson) {
        return BaseUrlMitraModel.fromMap(baseUrlJson as Map<String, dynamic>);
      }).toList();

      setFront1Dot0GlobalLink(value);

      globalBaseUrlLinks.value = listOfBaseUrl;
    });
  }

  setFront1Dot0GlobalLink(Map<String, dynamic> value) {
    // Crie a lista de objetos de link do front 1.0
    // Obtenha a lista de URLs base do mapa
    List<dynamic> listOf1Dot0FrontUrlJson =
        value['listIframe1Dot0FrontLink'] as List<dynamic>;
    List<BaseUrlMitraModel> listOf1Dot0FrontUrl =
        listOf1Dot0FrontUrlJson.map((baseUrlJson) {
      return BaseUrlMitraModel.fromMap(baseUrlJson as Map<String, dynamic>);
    }).toList();

    global1Dot0FrontUrlLinks.value = listOf1Dot0FrontUrl;
  }

  // handleDynamicLink() async {
  //   DynamicLinkService().fetchLinkData();
  // }

  hadLoggedUser() async {
    String? loggedUserToken = GetStorage().read(StoreTypes.userToken);
    if (loggedUserToken != null && loggedUserToken != '') {
      try {
        getLastAccessView();
        await workspaceController.getLastWorkspaceAccess(lastAccessView.value);
        await userController.getLoggedUserData();
        Get.offNamed(AppPages.HOME_PAGE, arguments: lastAccessView.value);
      } catch (e) {
        GetStorage().remove(StoreTypes.userToken);
        //NOTE: Preciso desse timer para aguardar os controllers instanciarem.
        Timer(const Duration(milliseconds: 1000), () {
          Get.toNamed(AppPages.LOGIN);
        });
      }
    } else {
      Timer(const Duration(milliseconds: 1000), () {
        Get.toNamed(AppPages.LOGIN);
      });
    }
  }

  getLastAccessView() {
    var tempLastAcess = GetStorage().read(StoreTypes.lastAccessView);
    if (tempLastAcess != null) {
      if (tempLastAcess is Map<String, dynamic> &&
          tempLastAcess['workspaceId'] != null) {
        lastAccessView.value = LastAccessView.fromMap(tempLastAcess);
      } else {
        lastAccessView.value = LastAccessView.fromJson(tempLastAcess);
      }
    }
  }

  //NOTE: No caso de ter desktop, acrescentar os paramentros.
  setGlobalUserDisplay(BoxConstraints constraints) {
    globalDisplayHeight = constraints.maxHeight;
    //NOTE: Para tablets, width maior que 480.
    if (constraints.maxWidth >= 800) {
      globalUserDisplay = GlobalUserDisplay.tablet;
      //NOTE: Aqui pega por x width por até 799 height
    } else if (constraints.maxHeight < 730) {
      globalUserDisplay = GlobalUserDisplay.smallPhone;
      //NOTE: Aqui pega por width menor que 375 e height maior ou igual a 800
    } else if (constraints.maxWidth < 375) {
      globalUserDisplay = GlobalUserDisplay.thinPhone;
      //NOTE: Aqui pega por width maior que 375 e height maior que 700 e menor que 800.
    } else if (constraints.maxHeight > 860) {
      globalUserDisplay = GlobalUserDisplay.proPhone;
      //NOTE: Aqui pega por width maior que 375 e height menor que 880.
    } else {
      globalUserDisplay = GlobalUserDisplay.normalPhone;
    }
  }

  getListOfMitraBottomSheetItemOfUrlFront() {
    List<MitraBottomSheetItemModel> tempDetailButtonList = [];
    for (var i = 0; i < globalBaseUrlLinks.length; i++) {
      MitraBottomSheetItemModel tempItem = MitraBottomSheetItemModel(
        isSelected: currentBaseUrlLink.value == globalBaseUrlLinks[i].link &&
            currentBaseUrlNameUrl.value == globalBaseUrlLinks[i].name,
        itemIcon: MitraCardIconWidget(
          cardIcon: 'initials',
          hexColor: '#7839EE',
          cardInitials: globalBaseUrlLinks[i].name,
        ),
        itemName: globalBaseUrlLinks[i].name,
        itemId: i,
      );
      tempDetailButtonList.add(tempItem);
    }

    return tempDetailButtonList;
  }

  setStorageCurrentBaseUrl() {
    GetStorage().remove(StoreTypes.currentBaseUrlLink);
    GetStorage().remove(StoreTypes.currentBaseNameUrlLink);
    GetStorage().write(StoreTypes.currentBaseUrlLink, currentBaseUrlLink.value);
    GetStorage()
        .write(StoreTypes.currentBaseNameUrlLink, currentBaseUrlNameUrl.value);
  }

  logout() async {
    workspaceController.tempUserTokenByWorkspace.value = '';
    StoreTypes.disposeAllStore();
    userController.disposeUserController();
    workspaceController.disposeWorkspaceController();
  }

  verifyIfWebViewFinishLoading() async {
    if (webViewStore.webViewLoading.value) {
      Timer(const Duration(milliseconds: 500), () {
        verifyIfWebViewFinishLoading();
      });
    } else {
      await hadLoggedUser();
    }
  }
}
