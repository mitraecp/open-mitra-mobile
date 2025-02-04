import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';

abstract class IWorkspaceRepository {
  Future<WorkspaceModel> getWorkspaceDataById(int workspaceId);
  Future<List<WorkspaceModel>> getListOfUserWorkspaces();
}
