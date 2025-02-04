import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_mitra_mobile/app/controllers/menu_page_controller.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_bottom_sheet_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/pages/menu/menu_about_app.view.dart';
import 'package:open_mitra_mobile/app/pages/menu/menu_report_error_view.dart';
import 'package:open_mitra_mobile/app/pages/menu/widgets/mitra_project_accordion_group_widget.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MenuPage extends GetView<MenuPageController> {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: _buildMenuHeaderBar(),
        appLeadingWidth: 0,
        appTitleSpacing: 0,
        appLeading: const SizedBox(),
        isToAddOnTopContainer: false.obs,
      ),
      body: _buildMenuBody(),
      // bottomNavigationBar: MitraBottomNavBarWidget(),
    );
  }

  Widget _buildMenuHeaderBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _openChangeWorkspace();
            },
            child: Obx(
              () => Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: GlobalColors.violet_200),
                child: _getCardIconWidget(
                    controller.workspaceController.selectWorkspace.value.name,
                    '#5720B7'),
              ),
            ),
          ),
          const SizedBox(width: SpacingScale.scaleOne),
          InkWell(
            onTap: () async {
              _openChangeWorkspace();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        controller
                            .workspaceController.selectWorkspace.value.name,
                        style: AppTheme.text_md(AppThemeTextStyleType.semibold),
                      ),
                    ),
                    const SizedBox(width: SpacingScale.scaleHalf),
                    const Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
                Text(
                  controller.userController.loggedUser.value.name ?? '',
                  style:
                      AppTheme.text_sm(AppThemeTextStyleType.regular).copyWith(
                    color: GlobalColors.grey_500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCardIconWidget(String cardIcon, String hexColor) {
    String initials = cardIcon[0] + cardIcon[1];
    // Crie e retorne o widget Text
    return SizedBox(
      width: 28,
      height: 28,
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTheme.text_xs(AppThemeTextStyleType.bold)
              .copyWith(fontWeight: FontWeight.w900, fontSize: 12)
              .copyWith(color: HexColor(hexColor)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMenuBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SpacingScale.scaleTwoAndHalf),

          // Home
          InkWell(
            onTap: () {
              controller.homeController
                  .handleChangeBottomNavBarItemByIndex(homeBottomBarIndex);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.home_outlined,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(
                    width: SpacingScale.custom(10),
                  ),
                  Text(
                    'Home',
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: GlobalColors.grey_700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: SpacingScale.scaleThree),

          // Minha conta
          InkWell(
            onTap: () {
              Get.toNamed(AppPages.PROFILE_PAGE);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outlined,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(
                    width: SpacingScale.custom(10),
                  ),
                  Text(
                    'my_account'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: GlobalColors.grey_700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: SpacingScale.scaleTwoAndHalf),

          const MitraDividerWidget(),

          // Projetos
          Obx(
            () => Padding(
              padding: controller.homeController.showProjectsInMenuPage.value
                  ? const EdgeInsets.symmetric(vertical: SpacingScale.scaleOne)
                  : const EdgeInsets.only(top: SpacingScale.scaleTwoAndHalf),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          controller.homeController.showProjectsInMenuPage.value
                              ? SpacingScale.scaleOneAndHalf
                              : 0,
                    ),
                    color:
                        controller.homeController.showProjectsInMenuPage.value
                            ? GlobalColors.grey_50
                            : Colors.white,
                    child: InkWell(
                      onTap: () {
                        controller.homeController.showProjectsInMenuPage.value =
                            !controller
                                .homeController.showProjectsInMenuPage.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: SpacingScale.scaleTwoAndHalf),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              color: GlobalColors.grey_500,
                              size: 24,
                            ),
                            SizedBox(
                              width: SpacingScale.custom(10),
                            ),
                            Text(
                              'projects'.tr,
                              style:
                                  AppTheme.text_md(AppThemeTextStyleType.medium)
                                      .copyWith(color: GlobalColors.grey_700),
                            ),
                            const Spacer(),
                            Obx(
                              () => controller.homeController
                                      .showProjectsInMenuPage.value
                                  ? const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: GlobalColors.violet_500,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: GlobalColors.grey_400,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Lista de Projetos
                  controller.homeController.showProjectsInMenuPage.value
                      ? _buildProjectListMenu(controller)
                      : const SizedBox()
                ],
              ),
            ),
          ),

          const SizedBox(height: SpacingScale.scaleTwoAndHalf),

          const MitraDividerWidget(),

          const SizedBox(height: SpacingScale.scaleTwoAndHalf),

          // Reportar erro
          InkWell(
            onTap: () {
              Get.to(
                () => const MenuReportErrorView(),
                transition: Transition.fadeIn,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_outlined,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(
                    width: SpacingScale.custom(10),
                  ),
                  Text(
                    'report_error'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: GlobalColors.grey_700),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: GlobalColors.grey_400,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: SpacingScale.scaleThree),

          // Sobre o app
          InkWell(
            onTap: () {
              Get.to(
                () => const MenuAboutAppView(),
                transition: Transition.fadeIn,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SpacingScale.scaleTwoAndHalf),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_outlined,
                    color: GlobalColors.grey_500,
                    size: 24,
                  ),
                  SizedBox(
                    width: SpacingScale.custom(10),
                  ),
                  Text(
                    'about_app'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: GlobalColors.grey_700),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: GlobalColors.grey_400,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lista de projetos
  Widget _buildProjectListMenu(MenuPageController controller) {
    return controller
            .workspaceController.selectWorkspace.value.projects.isNotEmpty
        ? MitraProjectAccordionGroupWidget(
            listOfProjects:
                controller.workspaceController.selectWorkspace.value.projects)
        : Padding(
            padding: const EdgeInsets.only(
              left: SpacingScale.scaleThree,
              right: SpacingScale.scaleThree,
              top: SpacingScale.scaleOneAndHalf,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_right_rounded,
                  color: GlobalColors.grey_400,
                ),
                SizedBox(width: SpacingScale.custom(10)),
                Text(
                  'empty_space'.tr,
                  style: AppTheme.text_md(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_400),
                ),
              ],
            ),
          );
  }

  Widget _buildHeaderOfBottomSheetWidget() {
    return Row(
      children: [
        Text(
          'Workspace',
          style: AppTheme.text_md(AppThemeTextStyleType.semibold),
        ),
        Obx(
          () => Text(
            ' (${controller.workspaceController.listOfUserWorkspaces.value.length})'
                .tr,
            style: AppTheme.text_md(AppThemeTextStyleType.regular)
                .copyWith(color: GlobalColors.grey_400),
          ),
        ),
      ],
    );
  }

  void _openChangeWorkspace() async {
    await controller.workspaceController.getListOfUserWorkspaces();
    controller.getListOfMitraBottomSheetItem();
    var tempList = controller.workspaceList;
    controller.searchTextController.text = '';

    showMitraBottomSheetWidget(
      headerTitle: _buildHeaderOfBottomSheetWidget(),
      listOfMitraBottomSheetItem: tempList,
      bottonSheetHeight: 300.00,
      searchTextController: controller.searchTextController,
      onChanged: (int workspaceId) {
        controller.workspaceController.changeWorkspaceById(workspaceId);
        controller.homeController.changeWorkspace.value = true;
        Get.back();
      },
    );
  }
}
