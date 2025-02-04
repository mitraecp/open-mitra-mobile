import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/current_user_model.dart';
import 'package:open_mitra_mobile/app/data/model/module_models/module_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';


class ModuleProvider extends GetConnect {
  Future<List<ModuleModel>> getModule(String username) async {
    
    var token = GetStorage().read('web_token'),
        headers = {'Authorization': "Bearer $token"},
        fullUrl = "${baseUrl}module?ref=true&username=$username";

    List<ModuleModel> modulesList = <ModuleModel>[];
    final response = await get(
      fullUrl,
      headers: headers,
      decoder: (body) {
        try {
          modulesList = modulesModelFromJson(body);
        } catch (e) {
          throw Exception(e);
        }
        return modulesList;
      },
    );

    if (response.statusCode == 200) {
      return modulesList;
    } else {
      throw Exception('Failed to load modules');
    }
  }

  Future<List<ScreenModel>> getScreenListByModule(int moduleId) async {

    var token = GetStorage().read('web_token'),
        headers = {'Authorization': "Bearer $token"},
        fullUrl = "${baseUrl}screen?moduleId=$moduleId";

    List<ScreenModel> screenList = <ScreenModel>[];
    final response = await get(
      fullUrl,
      headers: headers,
      decoder: (body) {
        try {
          screenList = screenModelFromJson(body);
        } catch (e) {
          throw Exception(e);
        }
        return screenList;
      },
    );

    if (response.statusCode == 200) {
      return screenList;
    } else {
      GetStorage().remove('logged_user');
      GetStorage().remove('web_token');
      GetStorage().remove('front_url');
      Get.offAllNamed(AppPages.LOGIN);
      AppSnackBar().defaultBar('', 'user_disconnected'.tr);
      throw Exception('Failed to load screenList');
    }
  }

  Future<void> userData(String username) async {

    var token = GetStorage().read('web_token'),
        headers = {'Authorization': "Bearer $token"},
        fullUrl = "${baseUrl}users/$username";

    final response = await get(
      fullUrl,
      headers: headers,
      decoder: (body) {
        try {
          globalCurrentUser = CurrentUserModel.fromJson(body);
        } catch (e) {
          throw Exception(e);
        }
        return null;
      },
    );

    if (response.statusCode != 200) {
      GetStorage().remove('logged_user');
      GetStorage().remove('web_token');
      GetStorage().remove('front_url');
      Get.offAllNamed(AppPages.LOGIN);
      AppSnackBar().defaultBar('', 'user_disconnected'.tr);
      throw Exception("Responde statuscode: ${response.statusCode}");
    }
  }

  Future<bool> sendReportError(
      {required String email, required String message}) async {
    final response = await post(
      "https://node-api.mitraecp.com/sendMail",
      {
        "email": email,
        "message": message,
        "mode": "mobile",
        "name": globalCurrentUser!.name,
        "subjects": globalEmailSuporteApp,
      },
    );
    if (response.statusCode != 200) {
      // throw Exception("Error code: ${response.statusCode}");
      return false;
    } else {
      return true;
    }
  }

  Future<List<FilterBarSelectionsModel>> getScreenSelections(
      int screenId) async {

    var token = GetStorage().read('web_token'),
        headers = {'Authorization': "Bearer $token"},
        fullUrl = "${baseUrl}filterBar/screenSelections?screenId=$screenId";

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
        GetStorage().remove('logged_user');
        GetStorage().remove('web_token');
        GetStorage().remove('front_url');
        Get.offAllNamed(AppPages.LOGIN);
        AppSnackBar().defaultBar('', 'user_disconnected'.tr);
      }
      throw Exception('Failed to load modules, error: ${response.statusCode}');
    }
  }
}
