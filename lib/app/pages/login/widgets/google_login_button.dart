import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

// ignore: must_be_immutable
class GoogleLoginButton extends StatelessWidget {
  bool isToShowIcon;
  Color bgButtonColor;
  Color textColor;
  AppButtonStyle googleAppStyle;
  String buttonText;

  GoogleLoginButton({
    this.isToShowIcon = true,
    this.googleAppStyle = AppButtonStyle.outlined,
    this.bgButtonColor = Colors.white,
    this.textColor = GlobalColors.grey_700,
    this.buttonText = 'google_login_button',
    th,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return AppButtonWidget(
      buttonColor: bgButtonColor,
      style: googleAppStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isToShowIcon
              ? Padding(
                  padding: const EdgeInsets.only(
                      right: SpacingScale.scaleOneAndHalf),
                  child: SvgPicture.asset(
                    'assets/svg/google_log_colorido.svg',
                    height: 24,
                    width: 24,
                  ),
                )
              : const SizedBox(),
          Text(
            buttonText.tr,
            style: AppTheme.text_md(AppThemeTextStyleType.medium)
                .copyWith(color: textColor),
          ),
        ],
      ),
      onPressed: () {
        controller.loginWithGoogle();
      },
    );
  }
}
