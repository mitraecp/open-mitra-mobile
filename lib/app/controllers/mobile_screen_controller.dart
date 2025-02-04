import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/detail_builder_controller.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/controllers/profile_controller.dart';
import 'package:open_mitra_mobile/app/controllers/project_controller.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/webview_store_controller.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_button_model.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_model.dart';
import 'package:open_mitra_mobile/app/data/model/iframe_models.dart/iframe_payload_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/activated_screen.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/data_entry_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/history_mobile_screen_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/javascrpit_callbacks.dart';

class MobileScreenController extends GetxController {
  final HomeController homeController = Get.find();
  final UserController userController = Get.find<UserController>();
  final ProjectController projectController = Get.find();
  final DetailBuilderController detailBuilderController = Get.find();
  final ProfileController profileController = Get.find();
  final WebViewStore webViewStore = Get.find();

  RxBool mobileScreenCanPop = false.obs;
  RxBool webViewLoading = true.obs, // Loading do webview
      loadAnimetedText = false.obs, // loading do texto que aparece na tela.
      isModalOnIframeOpen = false
          .obs, // bool de controle do nav bar quando tiver modal no iframe.
      loadingMobileScreen =
          false.obs; // loading do token e outros dados antes de pegar o url.

  RxInt clickToShowFrontVersion = 0.obs;
  RxString iframeFrontVersion = 'Carregando'.obs;

  RxBool loading = false.obs;
  Rx<ScreenModel> selectedScreen = ScreenModel().obs;
  //NOTE: Variaveis usadas no dataentry.
  DataEntryModel? dataEntryModel;
  TextEditingController dataEntryController = TextEditingController();
  RxInt indexAutoCompleteSelected = 0.obs;
  RxString columnDataEntryName = ''.obs;
  RxString oldDataEntryValue = ''.obs;
  RxString autoCompleteSearch = ''.obs;
  RxBool isUsingDataEntrySearch = false.obs,
      dataEntryActive = false.obs,
      loadingFilter = false.obs,
      loadingHeader = false.obs,
      historyRouteMobileOnHome = false.obs,
      firstReloadBeforeLoadingWebview = false.obs,
      isToShowHeaderMobileHeaderBar = false.obs;

  RxBool preloadingIframe = false.obs, // Quando o webview termina de carregar
      showWebViewIframe =
          false.obs; // Quando o iframe termina e tira a mensagem de loading.

  RxString iframeLoadingText = ''.obs;

  RxInt mobileHomeRouteScreenId = 0.obs;

  Rx<List<MitraBottomSheetItemModel>> tempDetailButtonList =
      Rx<List<MitraBottomSheetItemModel>>([]);

  RxBool iframeIsResponsive = false.obs;
  // Timer para controle do timeout
  Timer? _iframeResponseTimeout;

  Rx<List<HistoryMobileScreenModel>> historyOfSelectedScreen =
      Rx<List<HistoryMobileScreenModel>>([]);

  RxString currentWebViewUrl = ''.obs;

  Rx<ActivatedScreenModel> selectedMobileScreen = Rx(
    ActivatedScreenModel(
      canPublish: false,
      enableDashMode: false,
      id: -1,
      isMobile: true,
      name: '',
    ),
  );

  initController() async {
    historyOfSelectedScreen.value = [];
    disposeSelectedMobileScreen();
    loadingMobileScreen.value = true;
    selectedMobileScreen.value =
        ActivatedScreenModel.fromJson(Get.arguments['screen'].toJson());

    mobileHomeRouteScreenId.value = selectedMobileScreen.value.id;
    historyOfSelectedScreen.value.add(HistoryMobileScreenModel(
        id: selectedMobileScreen.value.id,
        name: selectedMobileScreen.value.name));

    await getSelectedScreenData();

    if (homeController.isProjectWithOnlyOneScreen.value) {
      historyRouteMobileOnHome.value = true;
    }

    setisToShowHeaderMobileHeaderBar();

    currentWebViewUrl.value = getWebUrl();
    webViewStore.changeCurrentUrl(currentWebViewUrl.value);
    iframeLoadingText.value =
        globalTipsOfUsage[Random().nextInt(globalTipsOfUsage.length)].tr;

    verifyIfWebViewFinishLoading();
    Timer(const Duration(milliseconds: 100), () {
      homeController.loadingRootNavigation.value = false;
      loadingMobileScreen.value = false;
    });
  }

  void reloadModule() async {
    if (selectedMobileScreen.value.id == mobileHomeRouteScreenId.value) {
      setupReturnToHome();
      webViewStore.reloadWebView(currentWebViewUrl.value);
    } else {
      webViewStore.postMessageWebView(GlobalJavaScriptCall().refreshComponents);
    }
  }

  setupReturnToHome() async {
    dataEntryModel = DataEntryModel();
    dataEntryActive.value = false;
    setisToShowHeaderMobileHeaderBar();
    await projectController.projectRepository
        .deleteTempFilterBarSelections(selectedMobileScreen.value.id);
    getScreenFilterBarSelections();
  }

  void reloadAndGoBackToHomeScreen() async {
    selectedMobileScreen.value.id = mobileHomeRouteScreenId.value;
    historyOfSelectedScreen.value
        .retainWhere((item) => item.id == selectedMobileScreen.value.id);

    if (detailBuilderController.selectedDetailBuilder.value.id != -1) {
      closeCurrentDetail();
    }

    callActionOpenScreen(historyOfSelectedScreen.value.last.id);

    setupReturnToHome();
  }

  updateRouteAndSelectedMobileScreen(
      int screenId, String screenName, bool isToAddHistory) async {
    loadingHeader.value = true;
    if (screenId == mobileHomeRouteScreenId.value) {
      await updateSelectedMobileScreen(screenId, screenName);
      historyOfSelectedScreen.value = [];
      historyOfSelectedScreen.value.add(HistoryMobileScreenModel(
          id: selectedMobileScreen.value.id,
          name: selectedMobileScreen.value.name));
      if (homeController.isProjectWithOnlyOneScreen.value) {
        historyRouteMobileOnHome.value = true;
      } else {
        historyRouteMobileOnHome.value = false;
      }
      webViewStore.postMessageWebView(GlobalJavaScriptCall().refreshComponents);
      Timer(const Duration(milliseconds: 500), () {
        setisToShowHeaderMobileHeaderBar();
      });
    } else {
      await updateSelectedMobileScreen(screenId, screenName);
      if (isToAddHistory) {
        historyOfSelectedScreen.value.add(HistoryMobileScreenModel(
            id: selectedMobileScreen.value.id,
            name: selectedMobileScreen.value.name));
      } else {
        webViewStore
            .postMessageWebView(GlobalJavaScriptCall().refreshComponents);
      }
      historyRouteMobileOnHome.value = false;
      setisToShowHeaderMobileHeaderBar();
    }

    loadingHeader.value = false;
  }

  setisToShowHeaderMobileHeaderBar() {
    if (homeController.isProjectWithOnlyOneScreen.value &&
        historyRouteMobileOnHome.value) {
      isToShowHeaderMobileHeaderBar.value = false;
    } else if (homeController.isProjectWithOnlyOneScreen.value &&
        mobileHomeRouteScreenId.value == selectedMobileScreen.value.id) {
      isToShowHeaderMobileHeaderBar.value = false;
    } else {
      isToShowHeaderMobileHeaderBar.value = true;
    }
  }

  Future updateSelectedMobileScreen(int screenId, String screenName) async {
    selectedMobileScreen.value.id = screenId;
    selectedMobileScreen.value.name = screenName;
  }

  bool isLastHistoryOfSelectedScreen() {
    return historyOfSelectedScreen.value.length == 1;
  }

  goBackHistory() {
    loadingHeader.value = true;
    if (historyOfSelectedScreen.value.length > 1) {
      historyOfSelectedScreen.value.removeLast();
    }

    if (historyOfSelectedScreen.value.last.id ==
            mobileHomeRouteScreenId.value &&
        homeController.isProjectWithOnlyOneScreen.value) {
      historyRouteMobileOnHome.value = true;
    }

    callActionOpenScreen(historyOfSelectedScreen.value.last.id);

    loadingHeader.value = false;
  }

  getSelectedScreenData() async {
    try {
      await projectController
          .getRefreshToken(projectController.selectedProject.value.id);
      selectedScreen.value = await projectController.projectRepository
          .getSelectedScreenData(projectController.mergeRefreshToken.value,
              selectedMobileScreen.value.id);

      selectedMobileScreen.value.name = selectedScreen.value.name ?? '';

      await projectController.projectRepository
          .deleteTempFilterBarSelections(selectedMobileScreen.value.id);

      getScreenFilterBarSelections();
    } catch (e) {
      Timer(const Duration(milliseconds: 1000), () {
        Get.back();
        AppSnackBar().defaultBar('', 'server_under_maintenance'.tr);
      });
    }
  }

  disposeSelectedMobileScreen() {
    selectedMobileScreen.value = ActivatedScreenModel(
      canPublish: false,
      enableDashMode: false,
      id: -1,
      isMobile: true,
      name: '',
    );
  }

  setSelectedScreen() {
    selectedMobileScreen.value =
        ActivatedScreenModel.fromJson(Get.arguments['screen'].toJson());
    ;
  }

  String getWebUrl() {
    int screenId = selectedMobileScreen.value.id;

    var username = userController.loggedUser.value.email,
        token = projectController.mergeRefreshToken.value.merge!.userToken,
        frontUrl = getGlobalFront1_0Url();

    var backUrl = '';
    if (projectController.mergeRefreshToken.value.merge!.backURL != null) {
      backUrl = projectController.mergeRefreshToken.value.merge!.backURL!;
    }

    var fullUrl =
        "$frontUrl/inlineLogin?inlineToken=$token&inlineUsername=$username&inlineScreenId=$screenId&showNavbar=false&inlinePbTapumeLoading=false&isMobileView=true&?isPreviewMode=true&isMobileSystemIOS=$userSystemIsIOS&bkApiUrl=$backUrl&mobileWithoutHeader=${!isToShowHeaderMobileHeaderBar.value}";

    // ignore: avoid_print
    print(fullUrl);
    return fullUrl;
  }

  Future getScreenFilterBarSelections() async {
    try {
      await projectController.projectRepository
          .getScreenFilterBarSelections(selectedScreen.value.id!)
          .then(
            (data) => {
              selectedScreen.value.filterBarSelectionsDimensions = data,
              selectedScreen.value.filterBarSelectionsDimensions!
                      .every((element) {
                return element.dimensionContents!.every((dimensionContent) =>
                        dimensionContent.isSelected == false) &&
                    element.startDay == null &&
                    element.endDay == null;
              })
                  ? selectedScreen.value.haveValueSelected.value = false
                  : selectedScreen.value.haveValueSelected.value = true,
              for (var item
                  in selectedScreen.value.filterBarSelectionsDimensions!)
                {
                  item.dimensionContents!.length == 1
                      ? selectedScreen.value.haveValueSelected.value = true
                      : null,
                },
            },
          )
          .then((value) {
        selectedScreen.value.loadingFilter.value = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  getListOfMitraBottomSheetItem() {
    tempDetailButtonList.value = [];
    for (var i = 0;
        i <
            detailBuilderController
                .selectedDetailButtonsWithTopFlag.value.length;
        i++) {
      final currentItem =
          detailBuilderController.selectedDetailButtonsWithTopFlag.value[i];

      MitraBottomSheetItemModel tempItem = MitraBottomSheetItemModel(
        isSelected: false,
        itemIcon: Text(
          '${currentItem.icon}_baseline',
          style: const TextStyle(
            fontFamily: 'MaterialIcons',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        itemName: currentItem.title,
        itemId: currentItem.id,
      );
      tempDetailButtonList.value.add(tempItem);
    }
  }

  callExecuteDetailButtonOnIframe(int buttonIdx) {
    DetailBuilderButtonModel? clickedButtonData = detailBuilderController
        .selectedDetailButtonsWithTopFlag.value
        .firstWhereOrNull((element) =>
            element.id == tempDetailButtonList.value[buttonIdx].itemId);

    IframePayloadModel iframePayloadModel = IframePayloadModel(
        messageType: 'EXECUTE-DETAIL-BUTTON', messageBody: clickedButtonData);

    String jsonPayload = iframePayloadModel.toJson();

    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);
    webViewStore.postMessageWebView(tempPostMessage);

    if (clickedButtonData != null &&
        clickedButtonData.executionType != 'SCREEN') {
      detailBuilderController.selectedDetailBuilder(
        DetailBuilderModel(name: '', id: -1),
      );
    }
  }

  callActionOpenScreen(int screenId) {
    IframePayloadModel iframePayloadModel = IframePayloadModel(
        messageType: 'mobileCallActionOpenScreen', messageBody: screenId);

    String jsonPayload = iframePayloadModel.toJson();

    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);
    webViewStore.postMessageWebView(tempPostMessage);
    webViewStore.postMessageWebView(GlobalJavaScriptCall().refreshComponents);
  }

  callExecutegetItemOfTimelineMenu(int buttonIdx) {
    IframePayloadModel iframePayloadModel = IframePayloadModel(
        messageType: 'EXECUTE-TIMELINE-ACTION-IDX', messageBody: buttonIdx);

    String jsonPayload = iframePayloadModel.toJson();

    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);
    webViewStore.postMessageWebView(tempPostMessage);
  }

  goRouteHome() {
    if (homeController.isProjectWithOnlyOneScreen.value) {
      String homeName = historyOfSelectedScreen.value
          .firstWhere((element) => element.id == mobileHomeRouteScreenId.value)
          .name;
      updateRouteAndSelectedMobileScreen(
          mobileHomeRouteScreenId.value, homeName, false);
      callActionOpenScreen(mobileHomeRouteScreenId.value);
    } else {
      homeController.goToNavigationHome();
    }
  }

  closeCurrentDetail() {
    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessage('CLOSE-DETAIL');
    webViewStore.postMessageWebView(tempPostMessage);
    detailBuilderController.selectedDetailBuilder(
      DetailBuilderModel(name: '', id: -1),
    );
  }

  verifyIfWebViewFinishLoading() {
    if (webViewLoading.value) {
      webViewLoading.value = webViewStore.webViewLoading.value;
      if (webViewStore.webViewLoading.value) {
        Timer(const Duration(milliseconds: 500), () {
          verifyIfWebViewFinishLoading();
        });
      } else {
        verifyIframeLoading();
      }
    }
  }

  verifyIframeLoading() {
    // ignore: prefer_interpolation_to_compose_strings
    iframeLoadingText.value = iframeLoadingText.value + '.';
    if (!webViewLoading.value && preloadingIframe.value) {
      showWebViewIframe.value = true;
    }
  }

  verifyIframeIsResponsive() {
    iframeIsResponsive.value = false;
    IframePayloadModel iframePayloadModel = IframePayloadModel(
      messageType: 'MOBILE-AI-VERIFY-IFRAME-RESPONSIVE',
      messageBody: '',
    );
    String jsonPayload = iframePayloadModel.toJson();
    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);
    webViewStore.postMessageWebView(tempPostMessage);
    // Configura o Timer de timeout
    _iframeResponseTimeout = Timer(const Duration(milliseconds: 1500), () {
      // Timeout atingido sem resposta
      if (!iframeIsResponsive.value) {
        reloadAndGoBackToHomeScreen();
        showWebViewIframe.value = false;
        webViewStore.reloadWebView(currentWebViewUrl.value);
      }
    });
  }

  void onIframeResponseReceived() {
    // Função chamada quando a resposta é recebida do iframe
    iframeIsResponsive.value = true;
    // Cancela o Timer de timeout, pois a resposta foi recebida
    _iframeResponseTimeout?.cancel();
  }
}
