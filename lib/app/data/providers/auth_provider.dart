import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/auth_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';

class AuthProvider extends GetConnect {
  WorkspaceController controllerWorkspace = Get.find();
  Future signInWithEmailAndPassword(AuthUserModel authUserModel) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": 'https://$appDomain'
    };
    var response = await post(
      "${baseUrl}mitraspace/auth/login",
      authUserModel.toJson(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future<String> googleSignInExternal() async {
    final _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? user;

    _googleSignIn.disconnect();

    try {
      await _googleSignIn.signIn().then((result) async {
        user = result;
        await result!.authentication.then(
          (value) {
            GetStorage()
                .write(StoreTypes.userToken, (value.accessToken).toString());
          },
        );
      });
    } on PlatformException catch (err) {
      throw Exception(err);
    } catch (e) {
      throw Exception(e);
    }

    if (user == null) {
      throw Exception();
    } else {
      return GetStorage().read(StoreTypes.userToken);
    }
  }

  Future<String> microsoftSignInExternal() async {
    final microsoftProvider = MicrosoftAuthProvider();
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);

      if (user.credential != null && user.credential!.accessToken != null) {
        GetStorage().write(
            StoreTypes.userToken, (user.credential!.accessToken).toString());
      }
    } on PlatformException catch (err) {
      // ignore: avoid_print
      print(err);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (user == null) {
      throw Exception();
    } else {
      return GetStorage().read(StoreTypes.userToken);
    }
  }

  Future<String> appleSignInExternal() async {
    final appleProvider = AppleAuthProvider();
    // UserCredential? user;
    try {
      var result =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      if (result.credential != null && result.credential!.accessToken != null) {
        // GetStorage().write(
        //     StoreTypes.userToken, (result.credential!.accessToken).toString());
      }

      // await _googleSignIn.signIn().then((result) async {
      //   user = result;
      //   await result!.authentication.then(
      //     (value) {
      //       GetStorage()
      //           .write(StoreTypes.userToken, (value.accessToken).toString());
      //     },
      //   );
      // });
    } on PlatformException catch (err) {
      throw Exception(err);
    } catch (e) {
      throw Exception(e);
    }

    throw Exception();
  }

  Future<Map<String, dynamic>> signInWithProviderToken(
      String userToken, String provider) async {
    final baseUrl = getGlobalBaseUrl();
    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": 'https://$appDomain'
    };

    var response = await post(
      "${baseUrl}mitraspace/login",
      {
        "loginCriteriaType": provider,
        "token": userToken,
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 307) {
      return {"error": 307};
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Map<String, dynamic>> signUserInMitraBaseWithSSO(
      String userToken) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": ""
    };
    var response = await post(
      "${baseUrl}mitraspace/user/ssoUser",
      {
        "loginCriteriaType": 'GOOGLE',
        "token": userToken,
      },
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> googleLogout() async {
    final googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.disconnect();
      return true;
    } catch (e) {
      throw Exception();
    }
  }

  Future signUpWithEmailAndPassword(AuthUserModel authUserModel) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await post(
      "${baseUrl}mitraspace/auth/signup",
      authUserModel.toJson(),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future validateVerificationCode(String email, String code) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await post(
      "${baseUrl}mitraspace/auth/verificationCode",
      {"email": email, "code": code},
      headers: headers,
    );

    if (response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future resendValidateCode(String email) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await post(
      "${baseUrl}mitraspace/auth/resendCode/",
      {"email": email},
      headers: headers,
    );

    if (response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future resetPassword(String email) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await post(
      "${baseUrl}mitraspace/auth/resetPassword",
      {"email": email},
      headers: headers,
    );

    if (response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future resetPasswordValidateCode(String email, String code) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await post(
      "${baseUrl}mitraspace/auth/resetPassword/validateCode",
      {"email": email, "code": code},
      headers: headers,
    );

    if (response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }

  Future changeUserPassword(String email, String newPassword) async {
    final baseUrl = getGlobalBaseUrl();

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Authorization": "",
      "Origin": baseUrl
    };

    var response = await put(
      "${baseUrl}mitraspace/auth/resetPassword",
      {
        "email": email,
        "newPassword": newPassword,
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error login status: ${response.statusCode}');
    }
  }
}
