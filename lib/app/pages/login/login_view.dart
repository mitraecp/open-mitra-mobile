import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/login_form_widget.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';
import '../../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * .04),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: SpacingScale.scaleTwoAndHalf),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: GlobalColors.grey_100),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: appProjectLogoUrl == ''
                                ? appProjectLocalLogoPath == ''
                                    ? Image.network(
                                        emptyLogoUrl,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        appProjectLocalLogoPath,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                : Image.network(
                                    appProjectLogoUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: SpacingScale.scaleOne),
                        Text(
                          appProjectName,
                          textAlign: TextAlign.center,
                          style:
                              AppTheme.text_md(AppThemeTextStyleType.semibold),
                        ),
                        _textLogin(),
                        const SizedBox(height: SpacingScale.scaleFive),
                        LoginFormWidget(constraints: constraints),
                        const SizedBox(height: SpacingScale.scaleFive),
                        const MitraDividerWidget(),
                        const SizedBox(height: SpacingScale.scaleFive),
                        _registerText(),
                        const Spacer(),
                        const AppVersionWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: SpacingScale.scaleThree),
      child: Text(
        'choose_login_option'.tr,
        textAlign: TextAlign.center,
        style: AppTheme.text_md(AppThemeTextStyleType.semibold),
      ),
    );
  }

  Widget _registerText() {
    return InkWell(
      onTap: () {
        controller.setScreensForResetPassword.value = false;
        Get.toNamed(AppPages.REGISTER);
      },
      child: RichText(
        text: TextSpan(
          text: 'dont_have_account'.tr,
          style: AppTheme.text_sm(AppThemeTextStyleType.regular)
              .copyWith(color: GlobalColors.grey_500),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'register'.tr,
              style: AppTheme.text_sm(AppThemeTextStyleType.medium).copyWith(
                color: GlobalColors()
                    .getSelectedAppPrimaryColor(appProjectPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
