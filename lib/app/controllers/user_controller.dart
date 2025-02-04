import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/interface/user_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';

class UserController extends GetxController {
  final IUserRepository repository;
  UserController({
    required this.repository,
  });

  Rx<LoggedUser> loggedUser = Rx(LoggedUser(language: 'pt-BR'));

  disposeUserController() {
    loggedUser.value = LoggedUser(language: 'pt-BR');
  }

  getLoggedUserData() async {
    loggedUser.value = await repository.getLoggedUserData();
    verifyLocaleLanguage();
  }

  verifyLocaleLanguage() {
    if (loggedUser.value.language == 'pt-BR') {
      Get.updateLocale(const Locale('pt'));
    } else {
      Get.updateLocale(const Locale('en'));
    }
  }

  changeLoggedUserName(String newName) async {
    loggedUser.value.name = newName;

    try {
      await repository.changeUserName(loggedUser.value);
    } catch (error) {
      AppSnackBar().defaultBar('', 'failed_change_name'.tr);
    }
  }

  changeLoggedUserLanguage(String newLanguage) {
    loggedUser.value.language = newLanguage;
    repository.changeUserLanguage(
      loggedUser.value.email!,
      loggedUser.value.id!,
      newLanguage,
    );
  }
}
