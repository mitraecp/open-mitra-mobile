import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';
import 'package:open_mitra_mobile/app/data/providers/project_provider.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/interface/project_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';

class ProjectRepository extends IProjectRepository {
  final ProjectProvider apiClient = ProjectProvider();

  @override
  Future<List<ProjectScreenModel>> getProjectScreenData(
      RefreshTokenModel mergeRefreshToken) async {
    return await apiClient.getProjectScreensData(mergeRefreshToken);
  }

  @override
  Future<RefreshTokenModel> refreshTokenOfProjectWithId(int projectId) async {
    RefreshTokenModel refreshTokenModel =
        await apiClient.refreshToken(projectId);
    GetStorage()
        .write(StoreTypes.mergeToken, refreshTokenModel.merge?.userToken);
    GetStorage().write(StoreTypes.mergeUrl, refreshTokenModel.merge?.backURL);
    return refreshTokenModel;
  }

  @override
  Future<ScreenModel> getSelectedScreenData(
      RefreshTokenModel mergeRefreshToken, int screenId) async {
    return await apiClient.getSelectedScreenData(mergeRefreshToken, screenId);
  }

  @override
  Future<List<FilterBarSelectionsModel>> getScreenFilterBarSelections(
      int screenId) async {
    return await apiClient.getScreenFilterBarSelections(screenId);
  }

  @override
  getScreenComponent(
      RefreshTokenModel mergeRefreshToken, String screenId) async {
    return await apiClient.getScreenComponentData(mergeRefreshToken, screenId);
  }

  @override
  getSourceComponent(
      RefreshTokenModel mergeRefreshToken, String sourceId) async {
    return await apiClient.getSourceComponentData(mergeRefreshToken, sourceId);
  }

  @override
  getListOfValideAiProjects(RefreshTokenModel mergeRefreshToken) {
    try {
      return apiClient.getListOfValideAiProjects(mergeRefreshToken);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> deleteTempFilterBarSelections(int screenId) {
    return apiClient.deleteTempScreenSelections(screenId);
  }

  @override
  getListOfValideAiProjectsWithKey(int workspaceId) {
    try {
      return apiClient.getListOfValideAiProjectsWithKey(workspaceId);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getTenantConfig(RefreshTokenModel mergeRefreshToken) {
    try {
      return apiClient.getTenantConfig(mergeRefreshToken);
    } catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<String> getPublishAppDnsByPin(String pin) {
    return apiClient.getPublishAppDnsByPin(pin);
  }
}
