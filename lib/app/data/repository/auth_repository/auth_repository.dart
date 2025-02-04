// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/auth_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/last_access_view.dart';
import 'package:open_mitra_mobile/app/data/repository/auth_repository/interface/auth_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/app/data/providers/auth_provider.dart';

class AuthRepositoryImp extends IAuthRepository {
  final AuthProvider apiClient = AuthProvider();

  @override
  loginWithEmail(AuthUserModel authUserModel) async {
    try {
      var data = await apiClient.signInWithEmailAndPassword(authUserModel);
      if (data.isNotEmpty && data['lastAccessView'] != null) {
        GetStorage().write(StoreTypes.userToken, data['token']);
        GetStorage().write(StoreTypes.lastAccessView, data['lastAccessView']);
        LastAccessView lastAccessView =
            LastAccessView.fromMap(data['lastAccessView']);

        return lastAccessView;
      } else {
        _returnLoginWithNoLastAccesView(data);
      }
      // return token;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  loginWithGoogle() async {
    try {
      // NOTE: Login google
      String? token = await apiClient.googleSignInExternal();
      return _authWithProvider(token, 'GOOGLE');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  loginWithMiscrosft() async {
    try {
      // NOTE: Login google
      String? token = await apiClient.microsoftSignInExternal();
      return _authWithProvider(token, 'MICROSOFT');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  loginWithApple() async {
    try {
      print('entrou no repo apple');
      // NOTE: Login google
      // ignore: unused_local_variable
      String? token = await apiClient.appleSignInExternal();
      // _authWithProvider(token, 'APPLE');
    } catch (e) {
      throw Exception(e);
    }
  }

  _authWithProvider(String? token, String provider) async {
    if (token != null || token != '') {
      // NOTE: Verifica se o usuario existe no Mitra
      var userData = await apiClient.signInWithProviderToken(token!, provider);

      // NOTE: Usuario ainda nao exite no mitra
      if (userData["error"] != null && userData["error"] == 307) {
        //NOTE: Crio ele no mitra
        var newUserData = await apiClient.signUserInMitraBaseWithSSO(token);

        //NOTE: Faço o login sem ultimo acesso.
        return _returnLoginWithNoLastAccesView(newUserData);

        // NOTE: Usuario existe no mitra e tem ultimo acesso
      } else if (userData.isNotEmpty && userData['lastAccessView'] != null) {
        GetStorage().write(StoreTypes.userToken, userData['token']);
        GetStorage()
            .write(StoreTypes.lastAccessView, userData['lastAccessView']);
        LastAccessView lastAccessView =
            LastAccessView.fromMap(userData['lastAccessView']);

        return lastAccessView;

        // NOTE: Usuario existe mas nao tem ultimo acesso.
      } else {
        return _returnLoginWithNoLastAccesView(userData);
      }
    }
  }

  _returnLoginWithNoLastAccesView(Map<String, dynamic> data) {
    GetStorage().write(StoreTypes.userToken, data['token']);
    GetStorage().write(
      StoreTypes.lastAccessView,
      LastAccessView(projectId: -1, workspaceId: -1).toString(),
    );
    return LastAccessView(projectId: -1, workspaceId: -1);
  }

  @override
  logoutWithGoogle() async {
    await apiClient.googleLogout();
  }

  @override
  signUpWithEmailAndPassword(AuthUserModel authUserModel) {
    return apiClient.signUpWithEmailAndPassword(authUserModel);
  }

  @override
  validateVerificationCode(String email, String code) {
    return apiClient.validateVerificationCode(email, code);
  }

  @override
  resendCode(String email) {
    return apiClient.resendValidateCode(email);
  }

  @override
  resetPassword(String email) {
    return apiClient.resetPassword(email);
  }

  @override
  resetPasswordValidateCode(String email, String code) {
    return apiClient.resetPasswordValidateCode(email, code);
  }

  @override
  changeUserPassword(String email, String newPassword) {
    return apiClient.changeUserPassword(email, newPassword);
  }

  // Future<String?> getFrontUrl() async {
  //   try {
  //     String? frontUrl = await apiClient.getFrontUrl();
  //     return frontUrl;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> getUserData() async {
  //   await apiClient.getUserData();
  // }
}