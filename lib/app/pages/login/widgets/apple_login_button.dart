import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return AppButtonWidget(
      style: AppButtonStyle.outlined,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: SpacingScale.scaleOneAndHalf),
            child: SvgPicture.asset(
              'assets/svg/apple_logo_preta.svg',
              height: 24,
              width: 24,
            ),
          ),
          Text('apple_login_button'.tr,
              style: AppTheme.text_md(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_700)),
        ],
      ),
      onPressed: () {
        controller.loginWithApple();
      },
    );
  }
}
