import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class ProjectProvider extends GetConnect {
  Future<RefreshTokenModel> refreshToken(int projectId) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };

    var response = await get(
      "${baseUrl}mitraspace/project/refreshedToken/$projectId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.body;
      RefreshTokenModel refreshTokenModel =
          RefreshTokenModel.fromMap(responseData);
      return refreshTokenModel;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future<List<ProjectScreenModel>> getProjectScreensData(
      RefreshTokenModel mergeRefreshToken) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/mergeModule/withScreens?onlyWithMobileScreen=true&onlyShowInMenu=true",
      // "$backUrl/mergeModule/withScreens?onlyWithMobileScreen=true",
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> responseData = response.body;
      List<ProjectScreenModel> listOfProjectScreenModel = responseData
          .map((map) => ProjectScreenModel.fromMap(map as Map<String, dynamic>))
          .toList();

      return listOfProjectScreenModel;
    } else if (response.statusCode == null) {
      throw Exception('server_under_maintenance'.tr);
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future<ScreenModel> getSelectedScreenData(
      RefreshTokenModel mergeRefreshToken, int screenId) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/screen/$screenId?pageWidth=406&pageHeight=739&withUniversalSource=true&accessScreenId=$screenId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      ScreenModel screenModel = ScreenModel.fromJson(response.body);

      return screenModel;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future<List<FilterBarSelectionsModel>> getScreenFilterBarSelections(
      int screenId) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl),
        fullUrl = "$frontUrl/filterBar/screenSelections?screenId=$screenId";

    List<FilterBarSelectionsModel> filterBarSelectionsModel = [];
    final response = await get(
      fullUrl,
      headers: headers,
      decoder: (body) {
        try {
          for (var item in body['filterBarContent']) {
            var temp = filterBarSelectionsModelFromJson(item);
            filterBarSelectionsModel.add(temp);
          }
        } catch (e) {
          throw Exception(e);
        }
        //NOTE: Ordernar o dia em primeiro lugar da lista.
        if (filterBarSelectionsModel != []) {
          for (var i = 0; i < filterBarSelectionsModel.length; i++) {
            if (filterBarSelectionsModel[i]
                        .dimensionContents!
                        .first
                        .dimensionId ==
                    globalDayFilterId &&
                i != 0) {
              var temp = filterBarSelectionsModel[i];

              filterBarSelectionsModel.removeAt(i);

              filterBarSelectionsModel.insert(0, temp);
            }
          }
        }
        return filterBarSelectionsModel;
      },
    );

    if (response.statusCode == 200) {
      return filterBarSelectionsModel;
    } else {
      if (response.statusCode == 403) {
        StoreTypes.disposeAllStore();
        // Get.offAllNamed(AppPages.INTRO_SCREEN);
        Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
        AppSnackBar().defaultBar('', 'user_disconnected'.tr);
      }
      throw Exception('Failed to load modules, error: ${response.statusCode}');
    }
  }

  Future<bool> deleteTempScreenSelections(int screenId) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl),
        fullUrl =
            "$frontUrl/screenSelection/deleteTempByScreen?screenId=$screenId";

    final response = await delete(
      fullUrl,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future getScreenComponentData(
    RefreshTokenModel mergeRefreshToken,
    String screenId,
  ) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/screenComponent?screenId=$screenId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = response.body[0];
      return data['id'];
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future getSourceComponentData(
    RefreshTokenModel mergeRefreshToken,
    String sourceId,
  ) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/source/$sourceId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future getListOfValideAiProjects(RefreshTokenModel mergeRefreshToken) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';
    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/workspaceQuota/projectsWithAnyAIDataset",
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future getListOfValideAiProjectsWithKey(int workspaceId) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };

    var response = await get(
      "${baseUrl}mitraspace/iaBaseConfig/configuredBaseIdsByWorkspaceId/$workspaceId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future getTenantConfig(RefreshTokenModel mergeRefreshToken) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';
    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/multiTenant/tenantConfig",
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.bodyString);
    }
  }

  Future<String> getPublishAppDnsByPin(String pin) async {
    final baseUrl = getGlobalBaseUrl();
    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": ''
    };

    var response = await get(
      "${baseUrl}mitraspace/project/mobile/$pin",
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.body;
      return responseData['publishAppDns'];
    } else {
      throw Exception('Get dns by pin failed');
    }
  }
}
