import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/menu_page_controller.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_base_text_field.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class BodySentReportError extends StatelessWidget {
  final MenuPageController controller;
  const BodySentReportError({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: const EdgeInsets.only(
              top: SpacingScale.scaleTwo,
              bottom: SpacingScale.scaleTwoAndHalf,
              left: SpacingScale.scaleTwoAndHalf,
              right: SpacingScale.scaleTwoAndHalf,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'body_sent_error_1'.tr,
                    style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                        .copyWith(color: GlobalColors.grey_500),
                    children: [
                      TextSpan(text: 'body_sent_error_2'.tr),
                      TextSpan(
                        text: globalSuporteEmail,
                        style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                            .copyWith(color: GlobalColors.violet_600),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: SpacingScale.scaleTwo),
                const MitraDividerWidget(),
                const SizedBox(height: SpacingScale.scaleTwo),
                MitraInputTextField(
                  obscureText: false,
                  controller: controller.emailFromReportError,
                  inputTitle: 'E-mail',
                  inputTitleStyle:
                      AppTheme.text_sm(AppThemeTextStyleType.medium)
                          .copyWith(color: GlobalColors.grey_700),
                  inputHintText: 'insert_your_email'.tr,
                  inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                      .copyWith(color: GlobalColors.grey_400),
                  showPassword: false,
                  inputTextType: TextInputType.emailAddress,
                  inputError: false,
                ),
                const SizedBox(height: 12),
                // TODO: criar componente texto grande.
                Text(
                  'problem_description'.tr,
                  style:
                      AppTheme.text_sm(AppThemeTextStyleType.medium).copyWith(
                    color: GlobalColors.grey_700,
                  ),
                ),
                Expanded(
                  // height: globalUserDisplay.name != 'smallPhone'
                  //     ? Get.height * .49
                  //     : Get.height * .33,
                  child: CustomTextField(
                    labelText: 'error_description'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelTextFontSize: 16,
                    labelColorText: GlobalColors.grey_500,
                    controller: controller.textReportError,
                    keyboardType: TextInputType.multiline,
                    //NOTE: Para expandir ate o final da coluna, preciso tirar o default de maxLines e passar expanded como true.
                    maxLines: null,
                    expanded: true,
                    textAlignVertical: TextAlignVertical.top,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
