import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';
import 'package:open_mitra_mobile/app/data/providers/workspace_provider.dart';
import 'package:open_mitra_mobile/app/data/repository/workspace_repository/interface/workspace_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class WorkspaceRepository extends IWorkspaceRepository {
  final WorkspaceProvider apiClient = WorkspaceProvider();

  @override
  Future<WorkspaceModel> getWorkspaceDataById(int workspaceId) async {
    try {
      WorkspaceModel workspaceModel =
          await apiClient.getWorkspaceById(workspaceId);
      return workspaceModel;
    } catch (e) {
      try {
        WorkspaceModel workspaceModelTemp =
            await apiClient.getWorkspaceByIdWithNoQueryParamMobile(workspaceId);
        return workspaceModelTemp;
      } catch (e) {
        StoreTypes.disposeAllStore();
        // Get.offAllNamed(AppPages.INTRO_SCREEN);
        Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
        throw Exception(e);
      }
    }
  }

  @override
  Future<List<WorkspaceModel>> getListOfUserWorkspaces() async {
    try {
      List<WorkspaceModel>? listOfWorkspaceModel =
          await apiClient.getListOfUserWorkspaces();
      if (listOfWorkspaceModel != null && listOfWorkspaceModel.isNotEmpty) {
        List<WorkspaceModel> tempNotEmptyList = listOfWorkspaceModel;
        return tempNotEmptyList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
