// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/apple_login_button.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/google_login_button.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/microsoft_login_button.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class LoginFormWidget extends GetView<LoginController> {
  final BoxConstraints constraints;

  const LoginFormWidget({
    super.key,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLoginButton(),
        // const SizedBox(height: SpacingScale.scaleThree),
        // GoogleLoginButton(),
        // const SizedBox(height: SpacingScale.scaleThree),
        // const MicrosoftLoginButton(),
        // const SizedBox(height: SpacingScale.scaleThree),
        // const AppleLoginButton()
      ],
    );
  }

  Widget _buildLoginButton() {
    return AppButtonWidget(
      style: AppButtonStyle.outlined,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: SpacingScale.scaleOne),
            child: Icon(
              Icons.email_outlined,
              color: GlobalColors.grey_700,
            ),
          ),
          Text(
            'continue_with_email'.tr,
            style: AppTheme.text_md(AppThemeTextStyleType.medium)
                .copyWith(color: GlobalColors.grey_700),
          ),
        ],
      ),
      onPressed: () {
        Get.toNamed(AppPages.EMAIL_LOGIN);
      },
    );
  }
}
