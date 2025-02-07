import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';

class WorkspaceProvider extends GetConnect {
  Future getWorkspaceById(int workspaceId) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken,
      "Origin": 'https://$appDomain'
    };
    var response = await get(
      // "${baseUrl}mitraspace/userSpaces/$workspaceId",
      "${baseUrl}mitraspace/userSpaces/$workspaceId?onlyWithMobileScreen=true",
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.body;
      WorkspaceModel workspaceModel = WorkspaceModel.fromMap(responseData);
      return workspaceModel;
    }
  }

  Future getWorkspaceByIdWithNoQueryParamMobile(int workspaceId) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken,
      "Origin": 'https://$appDomain'
    };
    var response = await get(
      "${baseUrl}mitraspace/userSpaces/$workspaceId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.body;
      WorkspaceModel workspaceModel = WorkspaceModel.fromMap(responseData);
      return workspaceModel;
    }
  }

  Future<List<WorkspaceModel>?> getListOfUserWorkspaces() async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken,
      "Origin": 'https://$appDomain'
    };
    var response = await get(
      // "${baseUrl}mitraspace/userSpaces",
      "${baseUrl}mitraspace/userSpaces?onlyWithMobileScreen=true",
      headers: headers,
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> responseData = response.body['spaceAccessViews'];
        List<WorkspaceModel> listOfWorkspaceModel = responseData
            .map((map) => WorkspaceModel.fromMap(map as Map<String, dynamic>))
            .toList();
        return listOfWorkspaceModel;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      return null;
    }
  }
}
