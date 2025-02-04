import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';

class UserProvider extends GetConnect {
  Future getLoggedUserData() async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };
    var response = await get(
      "${baseUrl}mitraspace/user/logged",
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.body;
      LoggedUser loggedUser = LoggedUser.fromMap(responseData);
      return loggedUser;
    }
  }

  Future signToWaitList(String userEmail) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };
    var response = await post(
      "${baseUrl}mitraspace/user/waitList",
      {
        "emailProspect": userEmail,
      },
      headers: headers,
    );
    return response.statusCode;
  }

  Future changeUserLanguage(
      String userEmail, int userId, String newLanguage) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };
    var response = await put(
      "${baseUrl}mitraspace/user/changeLanguage",
      {"emailProspect": userEmail, "id": userId, "language": newLanguage},
      headers: headers,
    );
    return response.statusCode;
  }

  Future changeUserName(LoggedUser loggedUser) async {
    final baseUrl = getGlobalBaseUrl();
    final userToken = "Bearer ${GetStorage().read(StoreTypes.userToken) ?? ''}";

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": userToken
    };

    var response = await put(
      "${baseUrl}mitraspace/user/${loggedUser.id}",
      loggedUser.toJson(),
      headers: headers,
    );
    
    return response.statusCode;
  }
}
