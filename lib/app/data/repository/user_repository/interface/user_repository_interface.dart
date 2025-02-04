import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';

abstract class IUserRepository {
  Future<LoggedUser> getLoggedUserData();
  signToWaitList(String userEmail);
  changeUserLanguage(String userEmail, int userId, String newLanguage);
  changeUserName(LoggedUser loggedUser);
}
