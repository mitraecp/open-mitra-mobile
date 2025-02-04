import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';

abstract class IProjectRepository {
  Future<RefreshTokenModel> refreshTokenOfProjectWithId(int projectId);
  Future<List<ProjectScreenModel>> getProjectScreenData(
      RefreshTokenModel mergeRefreshToken);

  Future<ScreenModel> getSelectedScreenData(
      RefreshTokenModel mergeRefreshToken, int screenId);

  Future<bool> deleteTempFilterBarSelections(int screenId);
  Future<List<FilterBarSelectionsModel>> getScreenFilterBarSelections(
      int screenId);
  getScreenComponent(RefreshTokenModel mergeRefreshToken, String screenId);
  getSourceComponent(RefreshTokenModel mergeRefreshToken, String sourceId);
  getListOfValideAiProjects(RefreshTokenModel mergeRefreshToken);
  getListOfValideAiProjectsWithKey(int workspaceId);
  getTenantConfig(RefreshTokenModel mergeRefreshToken);

  Future<String> getPublishAppDnsByPin(String pin);
}
