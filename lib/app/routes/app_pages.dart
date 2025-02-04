import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/bindings/home_binding.dart';
import 'package:open_mitra_mobile/app/bindings/intro_screen_binding.dart';
import 'package:open_mitra_mobile/app/bindings/mobile_screen_binding.dart';
import 'package:open_mitra_mobile/app/pages/home/home_view.dart';
import 'package:open_mitra_mobile/app/pages/home/home_without_workspace.dart';
import 'package:open_mitra_mobile/app/pages/home/home_workspace_quota_exceeded.dart';
import 'package:open_mitra_mobile/app/pages/home/project_with_mobile_screens_view.dart';
import 'package:open_mitra_mobile/app/pages/login/account_verified.dart';
import 'package:open_mitra_mobile/app/pages/login/check_your_email.dart';
import 'package:open_mitra_mobile/app/pages/login/create_user_view.dart';
import 'package:open_mitra_mobile/app/pages/login/email_login_view.dart';
import 'package:open_mitra_mobile/app/pages/login/forgot_password_view.dart';
import 'package:open_mitra_mobile/app/pages/login/login_view.dart';
import 'package:open_mitra_mobile/app/pages/login/register_view.dart';
import 'package:open_mitra_mobile/app/pages/login/set_password.dart';
import 'package:open_mitra_mobile/app/pages/menu/menu_view.dart';
import 'package:open_mitra_mobile/app/pages/mobile_screen/mobile_screen_view.dart';
import 'package:open_mitra_mobile/app/pages/profile/profile_view.dart';
import 'package:open_mitra_mobile/app/pages/splash_screen/splash_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const SPLASH_SCREEN_VIEW = Routes.SPLASH_SCREEN_VIEW;
  static const LOGIN = Routes.LOGIN;
  static const EMAIL_LOGIN = Routes.EMAIL_LOGIN;
  static const REGISTER = Routes.REGISTER;
  static const FORGOT_PASSWORD = Routes.FORGOT_PASSWORD;
  static const CREATE_USER = Routes.CREATE_USER;
  static const SET_PASSWORD = Routes.SET_PASSWORD;
  static const CHECK_EMAIL = Routes.CHECK_EMAIL;
  static const ACCOUNT_VERIFIED = Routes.ACCOUNT_VERIFIED;
  static const MENU_USER_PAGE = Routes.MENU_USER_PAGE;
  static const HOME_PAGE = Routes.HOME_PAGE;
  static const HOME_WITHOUT_WORKSPACE = Routes.HOME_WITHOUT_WORKSPACE;
  static const HOME_WORKSPACE_QUOTA_EXCEEDED = Routes.HOME_WORKSPACE_QUOTA_EXCEEDED;
  static const PROJECT_PAGE = Routes.PROJECT_PAGE;
  static const PROJECT_WITH_MOBILE_SCREEN = Routes.PROJECT_WITH_MOBILE_SCREEN;
  static const MOBILE_SCREEN = Routes.MOBILE_SCREEN;
  static const AI_SCREEN = Routes.AI_SCREEN;
  static const PROFILE_PAGE = Routes.PROFILE_PAGE;
  static const SEARCH_MENU = Routes.SEARCH_MENU;
  static const FILTER_BAR = Routes.FILTER_BAR;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN_VIEW,
      page: () => const SplashScreenView(),
      binding: IntroScreenBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.EMAIL_LOGIN,
      page: () => const EmailLoginView(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.CREATE_USER,
      page: () => const CreateUserPage(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.SET_PASSWORD,
      page: () => const SetPassowrdPage(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.CHECK_EMAIL,
      page: () => const CheckYourEmailPage(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.ACCOUNT_VERIFIED,
      page: () => const AccountVerifiedPage(),
      transitionDuration: const Duration(milliseconds: 150),
    ),
    // TODO: Ver se precisa do search
    // GetPage(
    //   name: _Paths.SEARCH_MENU,
    //   page: () => SearchMenuPage(),
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 150),
    // ),
    GetPage(
      name: _Paths.MENU_USER_PAGE,
      page: () => const MenuPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.PROFILE_PAGE,
      page: () => const ProfilePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.PROJECT_WITH_MOBILE_SCREEN,
      page: () => ProjectWithMobileScreens(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.HOME_WITHOUT_WORKSPACE,
      page: () => const HomeWithoutWorkspacePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.MOBILE_SCREEN,
      page: () => const MobileScreenView(),
      binding: MobileScreenBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: _Paths.HOME_WORKSPACE_QUOTA_EXCEEDED,
      page: () => const HomeWorkspaceQuotaExceededPage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),
  ];
}
