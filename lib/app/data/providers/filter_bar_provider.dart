import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/data/model/filter_bar/filter_bar_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class FilterBarProvider extends GetConnect {
  Future<FilterBarModel> getFilterBarConfigById(int filterBarId) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl),
        fullUrl =
            "$frontUrl/filterBar?id=$filterBarId&withOutFilterBarContent=true";

    FilterBarModel filterBarConfig = FilterBarModel();
    try {
      final response = await get(
        fullUrl,
        headers: headers,
        decoder: (body) {
          try {
            filterBarConfig = filterBarModelFromJson(body);
          } catch (e) {
            throw Exception(e);
          }
          //NOTE: Ordernar o dia em primeiro lugar da lista.
          for (var i = 0; i < filterBarConfig.filterBarContent!.length; i++) {
            if (filterBarConfig.filterBarContent![i].dimensionId ==
                    globalDayFilterId &&
                i != 0) {
              var temp = filterBarConfig.filterBarContent![i];

              filterBarConfig.filterBarContent!.removeAt(i);

              filterBarConfig.filterBarContent!.insert(0, temp);
            }
          }

          return filterBarConfig;
        },
      );
      if (response.statusCode == 200) {
        return filterBarConfig;
      } else if (response.statusCode == 403) {
        throw Exception('user_disconnected'.tr);
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      StoreTypes.disposeAllStore();
      // Get.offAllNamed(AppPages.INTRO_SCREEN);
      Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
      AppSnackBar().defaultBar('', 'user_disconnected'.tr);
      throw Exception('Failed to load modules');
    }
  }

  Future<List<FilterBarSelectionsModel>> getFilterBarSelectionsByFilterId(
      int screenId) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl),
        fullUrl = "${frontUrl}filterBar/selections?filterBarId=$screenId";

    List<FilterBarSelectionsModel> filterBarSelectionsModel = [];
    final response = await get(
      fullUrl,
      headers: headers,
      decoder: (body) {
        try {
          for (var item in body) {
            var temp = filterBarSelectionsModelFromJson(item);
            filterBarSelectionsModel.add(temp);
          }
        } catch (e) {
          throw Exception(e);
        }
        return filterBarSelectionsModel;
      },
    );

    if (response.statusCode == 200) {
      return filterBarSelectionsModel;
    } else {
      throw Exception('Failed to load modules');
    }
  }

  Future<void> setFilterDimensionContents({
    required int screenComponentId,
    required int screenId,
    required int dimensionId,
    required List<String> dimensionValue,
    bool isApplyFilter = false,
  }) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl);

    final response = await post(
      "$frontUrl/screenSelection",
      {
        'screenComponentId': screenComponentId,
        'screenSelectionTemp': {
          'screenId': screenId,
          'dimensionId': dimensionId
        },
        'values': dimensionValue,
      },
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 403) {
        StoreTypes.disposeAllStore();
        // Get.offAllNamed(AppPages.INTRO_SCREEN);
        Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
        AppSnackBar().defaultBar('', 'user_disconnected'.tr);
        throw Exception(
            "Error code: ${response.statusCode}, in filter: $dimensionValue");
      }
      throw Exception(
          "Error code: ${response.statusCode}, in filter: $dimensionValue");
    } else if (response.statusCode == 200) {
      if (isApplyFilter) {
        FilterBarController().finishApllyFilter();
      }
    }
  }

  Future<void> setDayFilterDimensionContents({
    required int screenComponentId,
    required int screenId,
    required int dimensionId,
    String? startDayId,
    String? endDayId,
    bool isApplyFilter = false,
  }) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl);

    final response = await post(
      "$frontUrl/screenSelection",
      {
        'screenComponentId': screenComponentId,
        'screenSelectionTemp': {
          'screenId': screenId,
          'dimensionId': dimensionId
        },
        'startDayId': startDayId,
        'endDayId': endDayId,
      },
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 403) {
        StoreTypes.disposeAllStore();
        // Get.offAllNamed(AppPages.INTRO_SCREEN);
        Get.offAllNamed(AppPages.SPLASH_SCREEN_VIEW);
        AppSnackBar().defaultBar('', 'user_disconnected'.tr);
        throw Exception("Error code: ${response.statusCode}");
      }
      throw Exception("Error code: ${response.statusCode} ");
    } else if (response.statusCode == 200) {
      if (isApplyFilter) {
        FilterBarController().finishApllyFilter();
      }
    }
  }

  Future<void> deleteTempFilters({required int screenId}) async {
    var token = GetStorage().read(StoreTypes.mergeToken),
        headers = {'Authorization': "Bearer $token"},
        frontUrl = GetStorage().read(StoreTypes.mergeUrl);

    final response = await delete(
      "$frontUrl/screenSelection/deleteTempByScreen?screenId=$screenId",
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception("Error code: ${response.statusCode}");
    }
  }
}
