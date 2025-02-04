import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/project_controller.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_model.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_icon_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/search_menu_item_model.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/main.dart';

class HomeController extends GetxController {
  final WorkspaceController workspaceController =
      Get.find<WorkspaceController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final UserController userController = Get.find<UserController>();

  RxBool homeLoading = false.obs,
      loadingRootNavigation = true.obs,
      aiPageLoading = true.obs,
      hasAiProject = false.obs,
      loadingRefreshProjects = false.obs,
      headerLoading = false.obs;

  RxInt selectedBottomNavBarIndex = 3.obs;
  Rx<ProjectModel?> lastAccessProject = Rx(
    ProjectModel(accessType: '', id: -1, name: '', projectConfig: null),
  );

  RxList<MitraBottomSheetItemModel> workspaceList =
      RxList<MitraBottomSheetItemModel>([]);

  TextEditingController searchWorkspaceTextController = TextEditingController();

  final TextEditingController searchTextController = TextEditingController();
  RxBool searchIsEmpty = true.obs,
      updateSearchReactive = false.obs,
      isMobileScreenSearchActived = false.obs;

  Rx<List<SearchMenuItem>> listOfSearchProjectItem = Rx(<SearchMenuItem>[]);

  RxBool showProjectsInMenuPage = false.obs,
      isToShowAppBarOnTopContainer = false.obs;

  RxDouble iframeMaxHeigth = 0.0.obs;

  PageController homePageViewController = PageController();
  RxInt homeCurrentPageIndex = 0.obs;

  PageController searchPageViewController = PageController();
  RxInt searchCurrentPageIndex = 0.obs;
  RxBool isSearchPageView = false.obs;
  RxInt idOfSelectedProjectScreenModel = 0.obs;
  RxString nameOfSelectedProjectScreenModel = ''.obs;

  RxBool mergeTokenError = false.obs;
  RxBool rebuildAiPage = false.obs;
  RxBool changeWorkspace = false.obs;
  RxBool isMultipleProjectsOrOneProjectWithAi = false.obs,
      isProjectWithOnlyOneScreen = false.obs;

  RxBool passingOnSelectedWorkspaceListiner = false.obs;

  @override
  void onInit() async {
    homeLoading.value = true;
    loadingRootNavigation.value = true;
    super.onInit();
    initHomeController();

    searchTextController.addListener(handleChangeSearchController);

    // Por mais que esse listener seja criado no home_controller,
    // quando o controller da intro_screen seleciona o workspace ja cai nesse listener.
    ever(workspaceController.selectWorkspace, (WorkspaceModel workspace) async {
      if (workspace.projects.isNotEmpty) {
        passingOnSelectedWorkspaceListiner.value = true;
        await loadInitialDataOfWorkspace(workspace);
        passingOnSelectedWorkspaceListiner.value = false;
      }
    });
  }

  loadInitialDataOfWorkspace(WorkspaceModel workspace) async {
    await workspaceController.sortProjectList();
    int currentProjectId = appProjectId;
    await projectController.getRefreshToken(currentProjectId);
    await projectController.getTenantConfig();
    homeLoading.value = false;
    goToProjectWithProjectId(currentProjectId, false);
  }

  initHomeController() async {
    try {
      if (!passingOnSelectedWorkspaceListiner.value &&
          workspaceController.selectWorkspace.value.id != -1) {
        loadInitialDataOfWorkspace(workspaceController.selectWorkspace.value);
      }
      lastAccessProject.value = workspaceController.getLastAccesProjectData();
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao iniciar home controller');
      throw Exception(e);
    }
  }

  setMultipleProjectsRootNavigation() {
    // Se entra no if é pq tem apenas um projeto
    if ((workspaceController.selectWorkspace.value.projects.length == 1 &&
            workspaceController.selectWorkspace.value.aiProjects!.isEmpty) ||
        (projectController.mobileHomeScreenId.value != 0 &&
            workspaceController.selectWorkspace.value.projects.length == 1)) {
      isMultipleProjectsOrOneProjectWithAi.value = false;
      int firstProjectId =
          workspaceController.selectWorkspace.value.projects[0].id;
      goToProjectWithProjectId(firstProjectId, false);
    } else {
      // se entrar no else é pq tem mais de um.
      isMultipleProjectsOrOneProjectWithAi.value = true;
      loadingRootNavigation.value = false;
    }
  }

  Future verifyUserHasAIProject() async {
    aiPageLoading.value = true;
    // await refreshProjectListBySelectedWorkspace();
    await projectController.getValideAiProjects();

    if (workspaceController.selectWorkspace.value.aiProjects != null &&
        workspaceController.selectWorkspace.value.aiProjects!.isNotEmpty) {
      hasAiProject.value = true;
    } else {
      hasAiProject.value = false;
    }
    aiPageLoading.value = false;
  }

  handleChangeSearchController() {
    updateSearchReactive.value = true;
    searchIsEmpty.value = searchTextController.text == '';

    if (routeHistoryObserver.currentRoute() ==
        AppPages.PROJECT_WITH_MOBILE_SCREEN) {
      updateSearchListWithMobileScreen();
    } else {
      getProjectListOfSearch();
    }

    if (!searchIsEmpty.value) {
      filterListOfSearchMenuItem(searchTextController.text);
    }

    Timer(const Duration(milliseconds: 200), () {
      updateSearchReactive.value = false;
    });
  }

  filterListOfSearchMenuItem(String searchText) {
    listOfSearchProjectItem.value = listOfSearchProjectItem.value
        .where((element) =>
            element.title!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  disposeHomeController() {
    selectedBottomNavBarIndex.value = homeBottomBarIndex;
    lastAccessProject.value =
        ProjectModel(accessType: '', id: -1, name: '', projectConfig: null);
    projectController.disposeProject();
    mergeTokenError.value = false;
    aiPageLoading.value = true;
    rebuildAiPage.value = true;
    isMultipleProjectsOrOneProjectWithAi = false.obs;
    isProjectWithOnlyOneScreen = false.obs;
    projectController.mobileHomeScreenId.value = 0;
    loadingRootNavigation.value = true;
  }

  Future<void> handleRefreshHomeView() async {
    homeLoading.value = true;
    await refreshProjectListBySelectedWorkspace();
    homeLoading.value = false;
  }

  Future<void> refreshProjectListBySelectedWorkspace() async {
    try {
      loadingRefreshProjects.value = true;

      await workspaceController.getListOfUserWorkspaces();
      await workspaceController
          .getWorkspaceById(workspaceController.selectWorkspace.value.id);
      int firstProjectId = appProjectId;
      await projectController.getRefreshToken(firstProjectId);
      await projectController.getValideAiProjects();
      loadingRefreshProjects.value = false;
    } catch (e) {
      loadingRefreshProjects.value = false;
      throw Exception(e);
    }
  }

  void handleChangeBottomNavBarItemByIndex(int index) {
    refreshProjectListBySelectedWorkspace();
    // index 1 =  Menu
    if (index == menuBottomBarIndex) {
      // Get.offAllNamed(AppPages.MENU_USER_PAGE);
      if (index == selectedBottomNavBarIndex.value &&
          routeHistoryObserver.currentRoute() != AppPages.MENU_USER_PAGE) {
        Get.back();
      } else {
        navigatePageRule(AppPages.MENU_USER_PAGE);
      }
      // index 2 =  Home
    } else if (index == homeBottomBarIndex) {
      isSearchPageView.value = false;
      if (index == selectedBottomNavBarIndex.value &&
          routeHistoryObserver.currentRoute() != AppPages.HOME_PAGE) {
        Get.back();
      } else {
        // Get.toNamed(AppPages.HOME_PAGE);
        navigatePageRule(AppPages.HOME_PAGE);

        // Se tiver projeto salvo no storage.
        int projectStoragedId =
            (GetStorage().read(StoreTypes.projectStoraged) ?? -1).toInt();
        if (projectStoragedId != -1) {
          goToProjectWithProjectId(projectStoragedId, false);
        }
      }

      // index 3 =  Search
    } else if (index == searchBottomBarIndex) {
      // Get.toNamed(AppPages.SEARCH_MENU);
      if (index == selectedBottomNavBarIndex.value &&
          routeHistoryObserver.currentRoute() != AppPages.SEARCH_MENU) {
        Get.back();
      } else {
        navigatePageRule(AppPages.SEARCH_MENU);
      }
    } 

    selectedBottomNavBarIndex.value = index;
  }

  navigatePageRule(String appPageString) {
    if (routeHistoryObserver.isRouteInStack(appPageString)) {
      Get.until((route) => route.settings.name == appPageString);
    } else {
      Get.toNamed(appPageString);
    }
  }

  navigateToMobilePageRule(String appPageString) {
    int howManyMobileAsInStack = 0;
    for (var i = 0; i < routeHistoryObserver.routeStack.length; i++) {
      if (routeHistoryObserver.routeStack[i] == AppPages.MOBILE_SCREEN) {
        howManyMobileAsInStack += 1;
      }
    }
    if (howManyMobileAsInStack > 1 &&
        routeHistoryObserver.currentRoute() == AppPages.MOBILE_SCREEN) {
      Get.back();
      Get.until((route) => route.settings.name == AppPages.MOBILE_SCREEN);
    } else {
      if (routeHistoryObserver.watIsBefore(AppPages.MOBILE_SCREEN) ==
          appPageString) {
        Get.until((route) => route.settings.name == AppPages.MOBILE_SCREEN);
      } else {
        Get.until((route) => route.settings.name == appPageString);
      }
    }
  }

  // Esse metodo é chamado apenas quando retorna por um Get.back();
  updateBottomIndex() {
    if (Get.currentRoute.contains('menu-page')) {
      selectedBottomNavBarIndex.value = menuBottomBarIndex;
    } else if (Get.currentRoute.contains('home') ||
        Get.currentRoute.contains('mobile-screen')) {
      if (Get.currentRoute.contains('mobile-screen')) {
        //NOTE: Ja tem mais de um mobile aberto entao volta
        Get.back();
        projectController
            .getRefreshToken(projectController.selectedProject.value.id);
      }
      selectedBottomNavBarIndex.value = homeBottomBarIndex;
    } else if (Get.currentRoute.contains('search-menu')) {
      selectedBottomNavBarIndex.value = searchBottomBarIndex;
    }
  }

  handleHomePageViewChanged(int currentPageIndex) {
    homeCurrentPageIndex.value = currentPageIndex;
  }

  handleSearchPageViewChanged(int currentPageIndex) {
    searchCurrentPageIndex.value = currentPageIndex;
  }

  goToProjectWithProjectId(int id, bool isFromSearchPage) async {
    headerLoading.value = true;
    final ProjectModel? tempSelectedProject = workspaceController
        .selectWorkspace.value.projects
        .firstWhereOrNull((element) => element.id == id);
    if (tempSelectedProject != null) {
      if (!isFromSearchPage) {
        GetStorage().write(StoreTypes.projectStoraged, tempSelectedProject.id);
      }
      projectController.setSelectedProject(tempSelectedProject);
      try {
        await projectController
            .getSelectedProjectRefreshTokenAndProjectScreenData();
        updateSearchListWithMobileScreen();
        setProjectWithOneOrMultipleScreensRoot();
        if (isMultipleProjectsOrOneProjectWithAi.value) {
          Get.toNamed(AppPages.PROJECT_WITH_MOBILE_SCREEN);
        } else {
          Get.offAllNamed(AppPages.PROJECT_WITH_MOBILE_SCREEN);
        }
        headerLoading.value = false;
      } catch (e) {
        headerLoading.value = false;
        refreshProjectListBySelectedWorkspace();
        AppSnackBar().defaultBar('', 'server_under_maintenance'.tr);
        throw Exception(e);
      }
    }
  }

  setProjectWithOneOrMultipleScreensRoot() {
    // Se entrar no if é um projeto apenas com uma tela mobile.
    if ((listOfSearchProjectItem.value.length == 1 ||
            projectController.mobileHomeScreenId.value != 0) &&
        !isMultipleProjectsOrOneProjectWithAi.value) {
      isProjectWithOnlyOneScreen.value = true;

      var mobileHomeScreen = listOfSearchProjectItem.value.firstWhereOrNull(
          (element) =>
              element.screen!.id == projectController.mobileHomeScreenId.value);

      // Se tiver uma tela marcado como home, entrou nela
      if (mobileHomeScreen != null) {
        Timer(const Duration(milliseconds: 300), () {
          Get.offAllNamed(AppPages.MOBILE_SCREEN, arguments: {
            'screen': mobileHomeScreen.screen,
            'projectId': mobileHomeScreen.projectId,
          });
        });
      } else {
        // Se não tiver tela home eu entro na primeira da lista.
        if (listOfSearchProjectItem.value.isNotEmpty) {
          Timer(const Duration(milliseconds: 300), () {
            Get.offAllNamed(AppPages.MOBILE_SCREEN, arguments: {
              'screen': listOfSearchProjectItem.value[0].screen,
              'projectId': listOfSearchProjectItem.value[0].projectId,
            });
          });
        } else {
          // Se a list for vazia set os loadings para cair na tela de projeto
          isProjectWithOnlyOneScreen.value = false;
          loadingRootNavigation.value = false;
        }
      }
    } else {
      // Se tiver mais de uma tela mobile cai na tela de projeto.
      isProjectWithOnlyOneScreen.value = false;
      loadingRootNavigation.value = false;
    }
  }

  signToWaitList() async {
    try {
      var data = await userController.repository
          .signToWaitList(userController.loggedUser.value.email ?? '');

      if (data == 200) {
        AppSnackBar().defaultBar('', 'email_added'.tr);
      } else if (data == 400) {
        AppSnackBar().defaultBar('', 'email_already_registered'.tr);
      } else {
        AppSnackBar().defaultBar('', 'error_adding_email'.tr);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  simpleLogout() {
    StoreTypes.disposeAllStore();
    // Get.offAllNamed(AppPages.INTRO_SCREEN);
    Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
  }

  getIframeMaxHeight(BoxConstraints constraints) {
    iframeMaxHeigth.value = constraints.maxHeight;
  }

  updateSearchListProjects() {
    updateSearchReactive.value = true;
    isMobileScreenSearchActived.value = false;
    getProjectListOfSearch();
    Timer(const Duration(milliseconds: 200), () {
      updateSearchReactive.value = false;
    });
  }

  updateSearchListWithMobileScreen() {
    updateSearchReactive.value = true;
    isMobileScreenSearchActived.value = true;
    getOnlyMobileScreenListOfSearch();

    updateSearchReactive.value = false;
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

  getProjectListOfSearch() {
    listOfSearchProjectItem.value = [];
    int currentPublisheProjectId = appProjectId;

    ProjectModel tempProjectItem = workspaceController
        .selectWorkspace.value.projects
        .firstWhere((element) => element.id == currentPublisheProjectId);

    SearchMenuItem tempItem = SearchMenuItem(
      projectId: tempProjectItem.id,
      title: tempProjectItem.name ?? '',
      subTitle: '',
      icon: tempProjectItem.projectConfig!.icon,
      hexColor: tempProjectItem.projectConfig!.color,
      itemType: SearchMenuEnum.project,
    );

    listOfSearchProjectItem.value.add(tempItem);
  }

  getOnlyMobileScreenListOfSearch() {
    listOfSearchProjectItem.value = [];
    for (var folderElement in projectController.selectedProjectScreen.value) {
      if (folderElement.activatedScreens != null &&
          folderElement.activatedScreens != []) {
        for (var screenElement in folderElement.activatedScreens!) {
          SearchMenuItem tempScreenItem = SearchMenuItem(
            projectId: projectController.selectedProject.value.id,
            screenId: screenElement.id,
            title: screenElement.name,
            subTitle:
                '${'in '.tr}${projectController.selectedProject.value.name ?? ''}',
            icon: 'mdiCellphone',
            hexColor: '#FF7839EE',
            itemType: SearchMenuEnum.screen,
            screen: screenElement,
          );
          listOfSearchProjectItem.value.add(tempScreenItem);
        }
      }
    }

    sortSearchMenuList();
  }

  sortSearchMenuList() {
    listOfSearchProjectItem.value.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!
          .toLowerCase()); // Comparação padrão quando ambos não são nulos
    });
  }

  goToNavigationHome() {
    loadingRootNavigation.value = true;
    if (isMultipleProjectsOrOneProjectWithAi.value) {
      Get.offAllNamed(AppPages.HOME_PAGE);
      projectController.disposeProject();
      updateSearchListProjects();
      Timer(const Duration(milliseconds: 200), () {
        loadingRootNavigation.value = false;
      });
    } else {
      Get.offAllNamed(AppPages.PROJECT_WITH_MOBILE_SCREEN);
      updateSearchListWithMobileScreen();
      Timer(const Duration(milliseconds: 200), () {
        loadingRootNavigation.value = false;
      });
    }
  }
}
