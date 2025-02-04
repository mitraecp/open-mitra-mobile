import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/last_access_view.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';
import 'package:open_mitra_mobile/app/data/repository/workspace_repository/interface/workspace_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';

class WorkspaceController extends GetxController {
  final IWorkspaceRepository repository;
  WorkspaceController({required this.repository});

  RxBool loadingWorkspaceBottomSheet = false.obs;

  Rx<WorkspaceModel> selectWorkspace = Rx(WorkspaceModel(
    accessType: '',
    id: -1,
    name: '',
    projects: [],
  ));

  Rx<List<WorkspaceModel>> listOfUserWorkspaces = Rx<List<WorkspaceModel>>([]);

  Rx<LastAccessView> userLastAccess = Rx(LastAccessView());

  RxInt loggedAppPublishRef = 0.obs;
  RxString tempUserTokenByWorkspace = ''.obs;

  disposeWorkspaceController() {
    selectWorkspace.value =
        WorkspaceModel(accessType: '', id: -1, name: '', projects: []);
    listOfUserWorkspaces.value = [];
    tempUserTokenByWorkspace.value = '';
    loggedAppPublishRef.value = -1;
    userLastAccess.value = LastAccessView();
  }

  Future getListOfUserWorkspaces() async {
    loadingWorkspaceBottomSheet = true.obs;
    listOfUserWorkspaces.value = await repository.getListOfUserWorkspaces();
    loadingWorkspaceBottomSheet = false.obs;
  }

  Future getWorkspaceById(int workspaceId) async {
    selectWorkspace.value = await repository.getWorkspaceDataById(workspaceId);
    setForTheProjectListAccordionSelectedToFalse();
    sortProjectList();
  }

  changeWorkspaceById(int workspaceId) async {
    await getWorkspaceById(workspaceId);
    GetStorage().write(StoreTypes.workspaceStoraged, workspaceId);
    GetStorage().remove(StoreTypes.projectStoraged);
  }

  getLastWorkspaceAccess(LastAccessView lastAccessView) async {
    try {
      // Se tiver workspace salvo no storage eu pego dele.
      int workspaceStoragedId =
          (GetStorage().read(StoreTypes.workspaceStoraged) ?? -1).toInt();
      if (workspaceStoragedId != -1) {
        await getWorkspaceById(workspaceStoragedId);

        // Se não eu pego do ultimo acesso.
      } else {
        userLastAccess.value = lastAccessView;
        if (lastAccessView.workspaceId != null) {
          await getWorkspaceById(lastAccessView.workspaceId!);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ProjectModel? getLastAccesProjectData() {
    return selectWorkspace.value.projects.firstWhereOrNull(
        (element) => element.id == userLastAccess.value.projectId);
  }

  sortProjectList() {
    selectWorkspace.value.projects.sort((a, b) {
      if (a.name == null && b.name == null) {
        return 0; // Ambos são nulos, consideramos iguais
      } else if (a.name == null) {
        return 1; // O nulo é considerado maior que qualquer valor não nulo
      } else if (b.name == null) {
        return -1; // O nulo é considerado menor que qualquer valor não nulo
      } else {
        return a.name!.toLowerCase().compareTo(b.name!
            .toLowerCase()); // Comparação padrão quando ambos não são nulos
      }
    });

    if (selectWorkspace.value.aiProjects != null) {
      selectWorkspace.value.aiProjects!.sort((a, b) {
        if (a.name == null && b.name == null) {
          return 0; // Ambos são nulos, consideramos iguais
        } else if (a.name == null) {
          return 1; // O nulo é considerado maior que qualquer valor não nulo
        } else if (b.name == null) {
          return -1; // O nulo é considerado menor que qualquer valor não nulo
        } else {
          return a.name!.toLowerCase().compareTo(b.name!
              .toLowerCase()); // Comparação padrão quando ambos não são nulos
        }
      });
    }
  }

  setForTheProjectListAccordionSelectedToFalse() {
    for (var i = 0; i < selectWorkspace.value.projects.length; i++) {
      // Se tiver projeto salvo no storage.
      int projectStoragedId =
          (GetStorage().read(StoreTypes.projectStoraged) ?? -1).toInt();
      if (projectStoragedId != -1 &&
          selectWorkspace.value.projects[i].id == projectStoragedId) {
        selectWorkspace.value.projects[i].accordionListSelected = true.obs;
      }
      selectWorkspace.value.projects[i].accordionListSelected = false.obs;
    }
  }

  setProjectAccordionSelectedIndex(int index) {
    bool hasSelected = selectWorkspace.value.projects
        .any((ProjectModel e) => e.accordionListSelected!.value == true);
    if (hasSelected) {
      for (var i = 0; i < selectWorkspace.value.projects.length; i++) {
        selectWorkspace.value.projects[i].accordionListSelected!.value = false;
      }
    }
    selectWorkspace.value.projects[index].accordionListSelected!.value = true;
  }
}
