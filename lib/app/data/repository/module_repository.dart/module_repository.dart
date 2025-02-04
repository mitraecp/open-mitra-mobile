

import 'package:open_mitra_mobile/app/data/model/module_models/module_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/screen_model.dart';
import 'package:open_mitra_mobile/app/data/providers/module_provider.dart';

class ModuleRepository {
  final ModuleProvider apiClient = ModuleProvider();

  Future<List<ModuleModel>> getAllModule(String username) {
    return apiClient.getModule(username);
  }

  Future<List<ScreenModel>> getScreenListByModule(int moduleId) {
    return apiClient.getScreenListByModule(moduleId);
  }

  Future<List<FilterBarSelectionsModel>> getScreenSelections(int screenId) {
    return apiClient.getScreenSelections(screenId);
  }

  getUserData(String username) {
    return apiClient.userData(username);
  }

  Future<bool> sendReportError(
      {required String email, required String message}) {
    return apiClient.sendReportError(email: email, message: message);
  }
}
