import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/auth_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/last_access_view.dart';
import 'package:open_mitra_mobile/app/data/model/workspace_models/workspace_model.dart';
import 'package:open_mitra_mobile/app/data/repository/auth_repository/interface/auth_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/get_storage_types.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final IAuthRepository repository;
  LoginController({required this.repository});

  final WorkspaceController workspaceController = Get.find();
  final UserController userController = Get.find();

  final formKey = GlobalKey<FormState>();
  final authSession = GetStorage();

  RxBool loading = false.obs;
  RxBool checkTermsOfUser = true.obs;
  RxBool showPassword = false.obs;
  RxBool completedFields = true.obs;
  RxBool isToShowAppBarOnTopContainer = false.obs;

  TextEditingController emailController = TextEditingController();
  RxBool emailOrPasswordError = false.obs;
  RxBool emailIsEmpty = true.obs;

  TextEditingController passwordController = TextEditingController();
  RxBool passwordIsEmpty = true.obs;
  RxBool passwordRuleLengthGreaterThanSix = true.obs;
  RxBool passwordRuleForUpperAndLowerCase = true.obs;
  RxBool passwordRuleNumber = true.obs;
  RxBool passwordAllRulesMatch = false.obs;

  TextEditingController nameController = TextEditingController();
  RxBool nameIsEmpty = true.obs;

  TextEditingController checkEmailController = TextEditingController();
  RxBool checkEmailIsEmpty = true.obs;
  RxBool codeSent = false.obs;
  RxBool codeError = false.obs;

  TextEditingController confirmPasswordController = TextEditingController();
  RxBool passwordsNotMatches = false.obs;
  RxBool confirmPasswordIsEmpty = true.obs;

  RxInt sendCheckEmailCodeTimer = 0.obs;

  late Timer timer;

  RxBool setScreensForResetPassword = false
      .obs; // Trocar widget das telas: set_password / account_verified , para resetPasseword flow.

  @override
  void onInit() {
    //NOTE: Listeners para verificar se os campos foram preenchidos para habilitar o entrar.
    emailController.addListener(handleChangeEmailController);
    passwordController.addListener(handleChangePasswordController);
    nameController.addListener(handleChangeNameController);
    checkEmailController.addListener(handleCheckEmailController);
    confirmPasswordController.addListener(handleConfirmPasswordController);

    super.onInit();
  }

  clearInputFields() {
    emailController.text = '';
    passwordController.text = '';
    emailOrPasswordError.value = false;
    emailIsEmpty.value = true;
  }

  handleChangeEmailController() {
    emailIsEmpty.value = emailController.text == '';
    verifyCompletedFields();
  }

  handleChangePasswordController() {
    passwordIsEmpty.value = passwordController.text == '';

    passwordRuleLengthGreaterThanSix.value =
        passwordController.text.length >= 6;

    verifyPasswordWithRegexRules();

    verifyCompletedFields();

    passwordAllRulesMatch.value = passwordRuleLengthGreaterThanSix.value &&
        passwordRuleForUpperAndLowerCase.value &&
        passwordRuleNumber.value;
  }

  handleCheckEmailController() {
    checkEmailIsEmpty.value = checkEmailController.text == '';

    if (codeError.value) {
      codeError.value = false;
    }
  }

  handleConfirmPasswordController() {
    confirmPasswordIsEmpty.value = confirmPasswordController.text != '';
  }

  verifyIfBothPasswordsMatches() {
    passwordsNotMatches.value =
        passwordController.text != confirmPasswordController.text;
  }

  handleClickResetPasswordButton() async {
    verifyIfBothPasswordsMatches();
    if (!passwordsNotMatches.value) {
      try {
        await repository.changeUserPassword(
            emailController.text, passwordController.text);
        Get.toNamed(AppPages.ACCOUNT_VERIFIED);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  //NOTE: Verificar se os campos foram preenchidos para habilitar o entrar.
  verifyCompletedFields() {
    completedFields.value =
        emailController.text == '' || passwordController.text == '';
  }

  handleChangeNameController() {
    nameIsEmpty.value = nameController.text == '';
  }

  verifyPasswordWithRegexRules() {
    bool containsUppercaseAndLowercase(String text) {
      // Verifica se a string contém pelo menos uma letra maiúscula e uma minúscula
      return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])').hasMatch(text);
    }

    bool containsNumber(String text) {
      // Verifica se a string contém pelo menos um número
      return RegExp(r'\d').hasMatch(text);
    }

    bool hasUppercase(String text) {
      return text.length == 1 &&
          text == text.toUpperCase() &&
          !containsNumber(text);
    }

    passwordRuleForUpperAndLowerCase.value = passwordController.text.length == 1
        ? hasUppercase(passwordController.text)
        : containsUppercaseAndLowercase(passwordController.text);

    passwordRuleNumber.value = containsNumber(passwordController.text);
  }

  disposePasswordAndRules() {
    passwordController.text = '';
    passwordIsEmpty.value = true;
    passwordRuleLengthGreaterThanSix.value = true;
    passwordRuleForUpperAndLowerCase.value = true;
    passwordRuleNumber.value = true;
    passwordAllRulesMatch.value = false;
  }

  disposeCheckEmail() {
    checkEmailController.text = '';
    checkEmailIsEmpty.value = true;
    codeSent.value = false;
    codeError.value = false;
    loading.value = false;
    stopCheckEmailCodeTimer();
  }

  startSendCheckEmailCodeTimer() {
    sendCheckEmailCodeTimer.value = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sendCheckEmailCodeTimer.value == 0) {
        timer.cancel(); // Para o contador quando atingir 0
      } else {
        sendCheckEmailCodeTimer.value--;
      }
    });
  }

  stopCheckEmailCodeTimer() {
    timer.cancel();
    sendCheckEmailCodeTimer.value = 0;
  }

  Future<void> loginWithEmail() async {
    setScreensForResetPassword.value = false;
    Get.focusScope!.unfocus();
    try {
      LastAccessView? lastAccessView = await repository.loginWithEmail(
        AuthUserModel(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      continueLoginWithLastAccessRules(lastAccessView);
    } catch (e) {
      AppSnackBar().defaultBar('', 'invalid_data'.tr);
    }
  }

  Future<void> loginWithGoogle() async {
    Get.focusScope!.unfocus();
    try {
      LastAccessView lastAccessView = await repository.loginWithGoogle();
      continueLoginWithLastAccessRules(lastAccessView);
    } catch (e) {
      AppSnackBar().defaultBar('', 'invalid_data'.tr);
      throw Exception(e);
    }
  }

  Future<void> loginWithMicrosoft() async {
    Get.focusScope!.unfocus();
    try {
      LastAccessView lastAccessView = await repository.loginWithMiscrosft();
      continueLoginWithLastAccessRules(lastAccessView);
    } catch (e) {
      AppSnackBar().defaultBar('', 'invalid_data'.tr);
      throw Exception(e);
    }
  }

  Future<void> loginWithApple() async {
    Get.focusScope!.unfocus();
    try {
      // ignore: unused_local_variable
      LastAccessView lastAccessView = await repository.loginWithApple();
      // continueLoginWithLastAccessRules(lastAccessView);
    } catch (e) {
      AppSnackBar().defaultBar('', 'invalid_data'.tr);
      throw Exception(e);
    }
  }

  continueLoginWithLastAccessRules(LastAccessView? lastAccessView) async {
    LastAccessView appPublishHasLastAccess = LastAccessView(
      workspaceId: appWorkspaceId,
      projectId: appProjectId,
    );
    GetStorage().remove(StoreTypes.lastAccessView);
    GetStorage().write(StoreTypes.lastAccessView, appPublishHasLastAccess);
    try {
      if (lastAccessView != null && lastAccessView.workspaceId != -1) {
        await workspaceController
            .getLastWorkspaceAccess(appPublishHasLastAccess);
        await userController.getLoggedUserData();
        Get.offAllNamed(AppPages.HOME_PAGE, arguments: appPublishHasLastAccess);
      } else {
        loginWithoutLastAcessRules();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  loginWithoutLastAcessRules() async {
    await userController.getLoggedUserData();
    await workspaceController.getListOfUserWorkspaces();
    // Se tiver algum workspaces cadastrado ao usuario coloco ele para logar no primeiro.
    if (workspaceController.listOfUserWorkspaces.value.isNotEmpty) {
      WorkspaceModel firstWorksapce =
          workspaceController.listOfUserWorkspaces.value[0];
      LastAccessView tempLastAcess = LastAccessView(
          workspaceId: firstWorksapce.id,
          projectId: firstWorksapce.projects[0].id);

      continueLoginWithLastAccessRules(tempLastAcess);
    } else {
      Get.offAllNamed(AppPages.HOME_WITHOUT_WORKSPACE);
    }
  }

  sendCheckEmailCode() async {
    loading.value = true;
    codeSent.value = true;
    startSendCheckEmailCodeTimer();
    await checkEmailCode();
  }

  resendCheckEmailCode() async {
    loading.value = true;
    codeSent.value = true;
    startSendCheckEmailCodeTimer();
    try {
      await repository.resendCode(emailController.text.trim());
      loading.value = false;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> checkEmailCode() async {
    try {
      await repository.validateVerificationCode(
        emailController.text.trim(),
        checkEmailController.text.trim(),
      );
      Get.toNamed(AppPages.ACCOUNT_VERIFIED);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      codeError.value = true;
    }
  }

  sendCheckEmailCodeOfResetPassword() async {
    loading.value = true;
    codeSent.value = true;
    startSendCheckEmailCodeTimer();
    await checkEmailCodeOfResetPassword();
  }

  Future<void> checkEmailCodeOfResetPassword() async {
    try {
      await repository.resetPasswordValidateCode(
        emailController.text.trim(),
        checkEmailController.text.trim(),
      );
      Get.toNamed(AppPages.SET_PASSWORD);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      codeError.value = true;
    }
  }

  signUpWithEmailAndPassword() async {
    try {
      await repository.signUpWithEmailAndPassword(
        AuthUserModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
        ),
      );
      codeSent.value = true;
      startSendCheckEmailCodeTimer();
      Get.toNamed(AppPages.CHECK_EMAIL);
    } catch (e) {
      // Get.offAllNamed(AppPages.INTRO_SCREEN);
      AppSnackBar().defaultBar('', 'user_already_rergistered'.tr);
    }
  }

  resetPassword() async {
    try {
      await repository.resetPassword(emailController.text.trim());
      setScreensForResetPassword.value = true;
      Get.toNamed(AppPages.CHECK_EMAIL, arguments: {'resetPassword': true});
    } catch (e) {
      AppSnackBar().defaultBar('', 'email_not_registered'.tr);
    }
  }

  //NOTE: Função para de esconder a senha.
  void togglevisibility() {
    showPassword.value = !showPassword.value;
  }

  logoutGoogle() async {
    await repository.logoutWithGoogle();
  }
}
