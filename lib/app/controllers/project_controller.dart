import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/interface/project_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class ProjectController extends GetxController {
  final IProjectRepository projectRepository;

  ProjectController({required this.projectRepository});

  final WorkspaceController workspaceController = Get.find();

  Rx<ProjectModel> selectedProject = Rx(
    ProjectModel(
      accessType: 'NONE',
      id: -1,
      name: '',
      projectConfig: null,
    ),
  );

  Rx<RefreshTokenModel> mergeRefreshToken = Rx(
    RefreshTokenModel(
      accessType: 'NONE',
      token: '',
      type: 'Bearer',
    ),
  );

  Rx<List<ProjectScreenModel>> selectedProjectScreen = Rx([]);
  Rx<List<ProjectScreenModel>> selectedProjectScreenWithOnlyMobileScreen =
      Rx([]);

  RxBool loadingProject = false.obs;

  RxInt lastProjectIdOfMergeRefreshToken = RxInt(-1);
  RxInt lastWorkspaceIdOfMergedRefreshToken = RxInt(-1);

  RxInt mobileHomeScreenId = 0.obs;

  setSelectedProject(ProjectModel project) {
    selectedProject.value = project;
  }

  setSelectedProjectById(int projectId) {
    selectedProject.value = workspaceController.selectWorkspace.value.projects
        .firstWhere((element) => element.id == projectId);
  }

  disposeProject() {
    selectedProject.value = ProjectModel(
      accessType: 'NONE',
      id: -1,
      name: '',
      projectConfig: null,
    );
    selectedProjectScreen.value = [];
    selectedProjectScreenWithOnlyMobileScreen.value = [];
    lastProjectIdOfMergeRefreshToken.value = -1;
    lastWorkspaceIdOfMergedRefreshToken.value = -1;
    mergeRefreshToken.value = RefreshTokenModel(
      accessType: 'NONE',
      token: '',
      type: 'Bearer',
    );
  }

  Future<List<ProjectScreenModel>> getRefreshToken(int projectId) async {
    try {
      // Verifico se estou puxando o merge token para o mesmo projeto e workspace.
      if (lastProjectIdOfMergeRefreshToken.value == projectId &&
          lastWorkspaceIdOfMergedRefreshToken.value ==
              workspaceController.selectWorkspace.value.id && mergeRefreshToken.value.merge != null) {
        return await projectRepository
            .getProjectScreenData(mergeRefreshToken.value);
      } else {
        // caso contrario salvo o que estou carregando
        lastProjectIdOfMergeRefreshToken.value = projectId;
        lastWorkspaceIdOfMergedRefreshToken.value =
            workspaceController.selectWorkspace.value.id;
        mergeRefreshToken.value =
            await projectRepository.refreshTokenOfProjectWithId(projectId);
        if (mergeRefreshToken.value.merge != null) {
          return await projectRepository
              .getProjectScreenData(mergeRefreshToken.value);
        } else {
          return [];
        }
      }
    } catch (e) {
      if (e.toString().contains('server_under_maintenance'.tr)) {
        AppSnackBar().defaultBar('', 'Servidor em manutenção');
      }
      if (e.toString().contains('exceededQuotas')) {
        Get.offAllNamed(AppPages.HOME_WORKSPACE_QUOTA_EXCEEDED);
      }
      throw Exception(e);
    }
  }

  Future getSelectedProjectRefreshTokenAndProjectScreenData() async {
    loadingProject.value = true;
    selectedProjectScreen.value = [];
    selectedProjectScreenWithOnlyMobileScreen.value = [];
    selectedProjectScreen.value =
        await getRefreshToken(selectedProject.value.id);
    setWithOnlyMobileScreen(selectedProjectScreen.value);
    setSelectedProjectScreenWithOnlyMobileScreen();
    sortSelectedProjectScreenWithOnlyMobileScreen();
    loadingProject.value = false;
  }

  getAccordionProjectRefreshTokenAndProjectScreenData(
      int indexOfAccordionProject) async {
    final ProjectModel selectedAccordionProject = workspaceController
        .selectWorkspace.value.projects[indexOfAccordionProject];

    selectedAccordionProject.accordionProjectScreenList.value =
        await getRefreshToken(selectedAccordionProject.id);

    selectedProject.value = selectedAccordionProject;

    setWithOnlyMobileScreen(
        selectedAccordionProject.accordionProjectScreenList.value);
    setSelectedProjectScreenWithOnlyMobileScreen();
    setAccordionProjectFolderAccordionSelectedToFalse(selectedAccordionProject);
  }

  setWithOnlyMobileScreen(List<ProjectScreenModel> projectScreenList) {
    for (var projectElement in projectScreenList) {
      if (projectElement.activatedScreens != null &&
          projectElement.activatedScreens is List) {
        if (projectElement.activatedScreens!.isNotEmpty) {
          // Ordeno a lista antes de passar para o selectedProjectScreenWithOnlyMobileScreen
          projectElement.activatedScreens!.sort(
            (a, b) => a.name.toLowerCase().compareTo(
                  b.name.toLowerCase(),
                ),
          );
          projectElement.activatedScreens = projectElement.activatedScreens!
              .where((element) => element.isMobile && element.canPublish)
              .toList();
        }
      }
    }
  }

  setSelectedProjectScreenWithOnlyMobileScreen() {
    for (var projectElement in selectedProjectScreen.value) {
      if (projectElement.activatedScreens != null &&
          projectElement.activatedScreens is List) {
        if (projectElement.activatedScreens!.isNotEmpty) {
          selectedProjectScreenWithOnlyMobileScreen.value.add(projectElement);
        }
      }
    }
  }

  sortSelectedProjectScreenWithOnlyMobileScreen() {
    selectedProjectScreenWithOnlyMobileScreen.value.sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    );
  }

  setAccordionProjectFolderAccordionSelectedToFalse(
      ProjectModel selectedAccordionProject) {
    for (var i = 0;
        i < selectedAccordionProject.accordionProjectScreenList.value.length;
        i++) {
      selectedAccordionProject.accordionProjectScreenList.value[i]
          .accordionProjectFolderSelected = false.obs;
    }
  }

  setSelectedAccordionProjectFolder(
      List<ProjectScreenModel> currentProjectScreenModel, int folderIndex) {
    bool hasSelected = currentProjectScreenModel.any((ProjectScreenModel e) =>
        e.accordionProjectFolderSelected!.value == true);
    if (hasSelected) {
      for (var i = 0; i < currentProjectScreenModel.length; i++) {
        currentProjectScreenModel[i].accordionProjectFolderSelected!.value =
            false;
      }
    }
    currentProjectScreenModel[folderIndex]
        .accordionProjectFolderSelected!
        .value = true;
  }

  unSelectAccordionProjectsAndFolder() {
    // tiro a seleção dos projetos selecionados.
    for (var workspaceProject
        in workspaceController.selectWorkspace.value.projects) {
      // Se tiver projeto salvo no storage.
      int projectStoragedId =
          (GetStorage().read(StoreTypes.projectStoraged) ?? -1).toInt();
      if (projectStoragedId != -1 && workspaceProject.id == projectStoragedId) {
        workspaceProject.accordionListSelected!.value = true;
      } else {
        workspaceProject.accordionListSelected!.value = false;
      }

      // tiro a seleção das pastas selecionadas.
      for (var projectFolder
          in workspaceProject.accordionProjectScreenList.value) {
        projectFolder.accordionProjectFolderSelected!.value = false;
      }
    }
  }

  getValideAiProjects() async {
    try {
      workspaceController.selectWorkspace.value.aiProjects = [];
      var tempList = await projectRepository
          .getListOfValideAiProjects(mergeRefreshToken.value);

      var tempListWithKey =
          await projectRepository.getListOfValideAiProjectsWithKey(
              workspaceController.selectWorkspace.value.id);

      if (tempList.isNotEmpty || tempListWithKey.isNotEmpty) {
        var filteredProjects =
            workspaceController.selectWorkspace.value.projects;

        if (tempList.isNotEmpty) {
          filteredProjects = filteredProjects
              .where((project) =>
                  tempList['projectsWithDataset'].contains(project.id))
              .toList();
        }

        if (tempListWithKey.isNotEmpty) {
          filteredProjects = filteredProjects
              .where(
                  (project) => tempListWithKey['baseIds'].contains(project.id))
              .toList();
        }

        workspaceController.selectWorkspace.value.aiProjects = filteredProjects;
      }
    } catch (e) {
      print(e);
      workspaceController.selectWorkspace.value.aiProjects = [];
    }
  }

  Future getTenantConfig() async {
    var tenantConfig =
        await projectRepository.getTenantConfig(mergeRefreshToken.value);
    if (tenantConfig['mobileHomeScreenId'] != null) {
      mobileHomeScreenId.value = tenantConfig['mobileHomeScreenId'];
    }
  }
}
