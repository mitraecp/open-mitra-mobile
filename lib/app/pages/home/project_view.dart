import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_icon_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/search_menu_item_model.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    homeController.isMobileScreenSearchActived.value = false;
    return RefreshIndicator(
      onRefresh: () {
        return homeController.handleRefreshHomeView();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchInput(context),
            Obx(
              () => homeController.hasAiProject.value &&
                      !homeController.aiPageLoading.value
                  ? const SizedBox(height: SpacingScale.scaleTwo)
                  : const SizedBox(),
            ),
            _buildIACardOption(),
            const SizedBox(height: SpacingScale.scaleTwo),
            Obx(
              () => homeController.updateSearchReactive.value
                  ? const SizedBox()
                  : SingleChildScrollView(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            homeController.listOfSearchProjectItem.value.length,
                        itemBuilder: (context, index) {
                          SearchMenuItem currentItem = homeController
                              .listOfSearchProjectItem.value[index];

                          return InkWell(
                            onTap: () {
                              homeController.searchTextController.text = '';
                              homeController.goToProjectWithProjectId(
                                  currentItem.projectId!, false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: SpacingScale.scaleTwo),
                              child: MitraCardWidget(
                                  cardIcon: MitraCardIconWidget(
                                    cardIcon: currentItem.icon != 'initials'
                                        ? currentItem.icon!
                                        : 'initials',
                                    cardInitials: currentItem.title ?? '',
                                    hexColor: currentItem.hexColor!,
                                    iconInitialsSize: 18,
                                  ),
                                  cardIconColor:
                                      HexColor(currentItem.hexColor!),
                                  cardTitle: currentItem.title ?? '',
                                  cardTitleStyle: AppTheme.text_md(
                                      AppThemeTextStyleType.medium)),
                            ),
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Obx(
      () => MitraInputTextField(
        isToShowTitle: false,
        obscureText: false,
        controller: homeController.searchTextController,
        inputTitle: '',
        inputShadowColorDefault: GlobalColors.grey_25,
        inputTitleStyle: AppTheme.text_md(AppThemeTextStyleType.regular)
            .copyWith(color: GlobalColors.grey_900),
        inputHintText: 'search_2'.tr,
        inputHintStyle: AppTheme.text_md(AppThemeTextStyleType.regular)
            .copyWith(color: GlobalColors.grey_500),
        showPassword: false,
        inputTextType: TextInputType.emailAddress,
        inputError: false,
        prefixIconWidget: const Icon(
          Icons.search,
          size: 20,
          color: GlobalColors.grey_500,
        ),
        suffixIconWidget: homeController.searchIsEmpty.value
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  homeController.searchTextController.text = '';
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: GlobalColors.grey_500,
                ),
              ),
      ),
    );
  }

  Widget _buildIACardOption() {
    return Obx(
      () => homeController.hasAiProject.value &&
              !homeController.aiPageLoading.value
          ? InkWell(
              onTap: () => {
                homeController.searchTextController.text = '',
                Get.toNamed(AppPages.AI_SCREEN),
              },
              child: MitraCardWidget(
                cardIcon: SvgPicture.asset(
                  'assets/svg/lila-gradient-head.svg',
                  height: 20,
                  width: 18,
                ),
                cardBoxShadow: GlobalColors.shadow_violet,
                cardBorderColor: GlobalColors.appPrimary_200,
                cardIconBackgroundSize: 2,
                cardIconColor: Colors.white,
                cardTitle: 'Lila'.tr,
                sufixWidget: _buildSufixIAText(),
                cardTitleStyle: AppTheme.text_md(AppThemeTextStyleType.medium),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildSufixIAText() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: GlobalColors.appPrimary_100,
      ),
      padding: const EdgeInsets.symmetric(
          vertical: SpacingScale.scaleHalf, horizontal: SpacingScale.scaleOne),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: GlobalColors.appPrimary_500,
            size: 16,
          ),
          const SizedBox(width: SpacingScale.scaleHalf),
          Text(
            'talk_with_your_data'.tr,
            style: AppTheme.text_xs(AppThemeTextStyleType.medium)
                .copyWith(color: GlobalColors.appPrimary_600),
          )
        ],
      ),
    );
  }
}
