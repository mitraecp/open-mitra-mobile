import 'package:open_mitra_mobile/app/data/model/user_models/auth_model.dart';

abstract class IAuthRepository {
  loginWithEmail(AuthUserModel authUserModel);
  loginWithGoogle();
  logoutWithGoogle();
  loginWithMiscrosft();
  loginWithApple();
  signUpWithEmailAndPassword(AuthUserModel authUserModel);
  validateVerificationCode(String email, String code);
  resendCode(String email);
  resetPassword(String email);
  resetPasswordValidateCode(String email, String code);
  changeUserPassword(String email, String newPassword);
}
