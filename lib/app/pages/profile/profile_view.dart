import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/profile_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_bottom_sheet_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';


class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'profile'.tr,
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
        isToAddOnTopContainer: controller.isToShowAppBarOnTopContainer,
      ),
      body: Column(
        children: [
          // User picture/name/email
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SpacingScale.scaleTwoAndHalf,
                vertical: SpacingScale.scaleTwo),
            child: Row(
              children: [
                _buildUserPhoto(),
                SizedBox(width: SpacingScale.custom(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width / 1.5,
                      child: Text(
                        controller.userController.loggedUser.value.name ?? '',
                        style: AppTheme.text_md(AppThemeTextStyleType.semibold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: Get.width / 1.5,
                      child: Text(
                        controller.userController.loggedUser.value.email ?? '',
                        style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                            .copyWith(
                          color: GlobalColors.grey_500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          const MitraDividerWidget(),

          // Nome
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SpacingScale.scaleTwoAndHalf,
                vertical: SpacingScale.scaleTwo),
            child: MitraInputTextField(
              disabled: controller.isToDisabledUserChangeName.value,
              obscureText: false,
              controller: controller.nameController,
              inputTitle: 'name'.tr,
              inputTitleStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_700),
              inputHintText: 'insert_your_name'.tr,
              inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_400),
              showPassword: false,
              inputTextType: TextInputType.name,
              inputError: false,
            ),
          ),

          const SizedBox(height: SpacingScale.scaleOne),

          const MitraDividerWidget(),

          const SizedBox(height: SpacingScale.scaleOneAndHalf),

          // Language
          InkWell(
            onTap: () {
              showMitraBottomSheetWidget(
                headerTitle: _buildHeaderOfBottomSheetWidget(),
                listOfMitraBottomSheetItem: controller.languageLocalesOptions(),
                cardIconBackground: GlobalColors.grey_25,
                onChanged: (int index) {
                  controller.changeLanguage(index);
                  Get.back();
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf,
                  vertical: SpacingScale.scaleOneAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.translate,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(width: SpacingScale.custom(10)),
                  Text(
                    'language'.tr,
                    style:
                        AppTheme.text_md(AppThemeTextStyleType.medium).copyWith(
                      color: GlobalColors.grey_700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Obx(
                    () => controller.userController.loggedUser.value.language ==
                            'pt-BR'
                        ? Text(
                            'brazilian_portuguese'.tr,
                            style:
                                AppTheme.text_xs(AppThemeTextStyleType.regular)
                                    .copyWith(
                              color: GlobalColors.grey_500,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'english'.tr,
                            style:
                                AppTheme.text_xs(AppThemeTextStyleType.regular)
                                    .copyWith(
                              color: GlobalColors.grey_500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  SizedBox(width: SpacingScale.custom(10)),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: GlobalColors.grey_400,
                    size: 24,
                  )
                ],
              ),
            ),
          ),

          // Deletar conta
          InkWell(
            onTap: () {
              controller.deleteUserAccount();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf,
                  vertical: SpacingScale.scaleOneAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_outlined,
                    color: GlobalColors.error_200, // GlobalColors.error_600
                    size: 24,
                  ),
                  SizedBox(width: SpacingScale.custom(10)),
                  Text(
                    'delete_account'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(
                            color: GlobalColors
                                .error_200), // GlobalColors.error_600
                  ),
                ],
              ),
            ),
          ),

          // Trocar de aplicativo
          InkWell(
            onTap: () {
              controller.switchApps();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf,
                  vertical: SpacingScale.scaleOneAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.swap_horiz_rounded,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(width: SpacingScale.custom(10)),
                  Text(
                    'switch_apps'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(
                            color: GlobalColors
                                .grey_700), // GlobalColors.error_600
                  ),
                ],
              ),
            ),
          ),

          // Sair
          InkWell(
            onTap: () => controller.logout(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf,
                  vertical: SpacingScale.scaleOneAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.exit_to_app,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(width: SpacingScale.custom(10)),
                  Text(
                    'logout'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: GlobalColors.grey_700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: MitraBottomNavBarWidget(),
    );
  }

  Widget _buildUserPhoto() {
    return controller.userController.loggedUser.value.picture != null
        ? SizedBox(
            width: 40,
            height: 40,
            child: ClipOval(
              child: Image.network(
                  controller.userController.loggedUser.value.picture ?? ''),
            ),
          )
        : ClipOval(
            child: Container(
              color: GlobalColors.appPrimary_600,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
  }

  Widget _buildHeaderOfBottomSheetWidget() {
    return Text(
      'select_language'.tr,
      style: AppTheme.text_md(AppThemeTextStyleType.semibold),
    );
  }
}
