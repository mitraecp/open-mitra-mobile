import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MenuAboutAppView extends StatelessWidget {
  const MenuAboutAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'about'.tr,
          style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
        ),
        appLeading: Padding(
          padding: const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 30,
            ),
          ),
        ),
        isToAddOnTopContainer: false.obs,
      ),
      body: _bodyWidget(),
      // bottomNavigationBar: MitraBottomNavBarWidget(),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.only(
        top: SpacingScale.scaleTwo,
        bottom: SpacingScale.scaleTwoAndHalf,
        left: SpacingScale.scaleTwoAndHalf,
        right: SpacingScale.scaleTwoAndHalf,
      ),
      child: Column(
        children: [
          Text(
            "Mitra Sheet",
            style: AppTheme.text_lg(AppThemeTextStyleType.bold),
          ),
          const SizedBox(height: SpacingScale.scaleOne),
          RichText(
            text: TextSpan(
              text: 'version'.tr,
              style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                  .copyWith(color: GlobalColors.grey_400),
              children: [
                TextSpan(
                  text: 'v$globalAppVersion',
                  style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_400),
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingScale.scaleTwo),
          RichText(
            text: TextSpan(
              text: 'body_sent_error_2'.tr,
              style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                  .copyWith(color: GlobalColors.grey_500),
              children: [
                TextSpan(
                  text: globalSuporteEmail,
                  style:
                      AppTheme.text_sm(AppThemeTextStyleType.regular).copyWith(
                    color: GlobalColors.violet_600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'about_app_text_2'.tr,
              style: AppTheme.text_sm(AppThemeTextStyleType.regular).copyWith(
                color: GlobalColors.grey_500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
