

import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/data/providers/user_provider.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/interface/user_repository_interface.dart';

class UserRepository extends IUserRepository {
  UserProvider apiClient = UserProvider();
  @override
  Future<LoggedUser> getLoggedUserData() async {
    try {
      return await apiClient.getLoggedUserData();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  signToWaitList(String userEmail) async {
    try {
      return await apiClient.signToWaitList(userEmail);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  changeUserLanguage(String userEmail, int userId, String newLanguage) {
    try {
      apiClient.changeUserLanguage(userEmail, userId, newLanguage);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  changeUserName(LoggedUser loggedUser) {
    try {
      apiClient.changeUserName(loggedUser);
    } catch (e) {
      throw Exception(e);
    }
  }
}
