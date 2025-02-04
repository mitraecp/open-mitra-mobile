import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/activated_screen.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_loading_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_root_header_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/search_menu_item_model.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class ProjectWithMobileScreens extends StatelessWidget {
  ProjectWithMobileScreens({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    homeController.isMobileScreenSearchActived.value = true;
    return Obx(
      () => homeController.loadingRootNavigation.value
          ? const Scaffold(
              body: Center(
                child: MitraLoadingWidget(),
              ),
            )
          : Scaffold(
              appBar: _buildProjectHeader(),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    height: constraints.maxHeight,
                    color: GlobalColors.grey_25,
                    child: Obx(
                      () => homeController
                              .projectController.loadingProject.isTrue
                          ? const Center(child: MitraLoadingWidget())
                          : RefreshIndicator(
                              onRefresh: () async {
                                await homeController.projectController
                                    .getSelectedProjectRefreshTokenAndProjectScreenData();
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: constraints.maxHeight,
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await homeController.projectController
                                          .getSelectedProjectRefreshTokenAndProjectScreenData();
                                    },
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                          height: homeController
                                                      .projectController
                                                      .selectedProjectScreenWithOnlyMobileScreen
                                                      .value
                                                      .length >
                                                  1
                                              ? null
                                              : constraints.maxHeight,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: SpacingScale
                                                      .scaleTwoAndHalf,
                                                  left: SpacingScale
                                                      .scaleTwoAndHalf,
                                                  right: SpacingScale
                                                      .scaleTwoAndHalf,
                                                ),
                                                child:
                                                    _buildSearchInput(context),
                                              ),
                                              homeController
                                                      .listOfSearchProjectItem
                                                      .value
                                                      .isNotEmpty
                                                  ? Obx(() => homeController
                                                          .updateSearchReactive
                                                          .value
                                                      ? const Center(
                                                          child:
                                                              MitraLoadingWidget(),
                                                        )
                                                      : _buildListOfProjectAndScreensWithMobileSCreen(
                                                          context))
                                                  : homeController
                                                          .updateSearchReactive
                                                          .value
                                                      ? const Center(
                                                          child:
                                                              MitraLoadingWidget(),
                                                        )
                                                      : _buildEmptyContainer(),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildProjectHeader() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () => homeController.headerLoading.value
            ? const SizedBox()
            : homeController.isProjectWithOnlyOneScreen.value ||
                    homeController.isMultipleProjectsOrOneProjectWithAi.value
                ? MitraAppBar(
                    appTitle: Obx(() => Text(
                          homeController.projectController.selectedProject.value
                                  .name ??
                              '',
                          style:
                              AppTheme.text_lg(AppThemeTextStyleType.semibold),
                        )),
                    appLeading: Padding(
                      padding: const EdgeInsets.only(
                          left: SpacingScale.scaleOneAndHalf),
                      child: IconButton(
                        onPressed: () {
                          homeController.searchTextController.text = '';
                          homeController.projectController.disposeProject();
                          homeController.updateSearchListProjects();
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_left_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                    isToAddOnTopContainer: false.obs,
                  )
                : MitraAppBar(
                    appTitle: MitraRootHeaderWidget(),
                    appLeadingWidth: 0,
                    appLeading: const SizedBox(),
                    appTitleSpacing: 0,
                    isToAddOnTopContainer: false.obs,
                  ),
      ),
    );
  }

  Widget _buildListOfProjectAndScreensWithMobileSCreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Lista das telas
          Obx(() => homeController.listOfSearchProjectItem.value.isNotEmpty
              ? _createProjectScreenListWidget()
              : const SizedBox()),
        ],
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

  Widget _buildEmptyContainer() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/svg/empty_image.svg',
            ),
            const SizedBox(height: SpacingScale.scaleThree),
            homeController.searchTextController.text != ''
                ? Text(
                    'Nenhuma tela mobile encontrada'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.regular)
                        .copyWith(
                      color: GlobalColors.grey_500,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'space_project_empty_now'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.regular)
                        .copyWith(
                      color: GlobalColors.grey_500,
                    ),
                    textAlign: TextAlign.center,
                  ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _createProjectScreenListWidget() {
    if (homeController.listOfSearchProjectItem.value.length > 1) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.listOfSearchProjectItem.value.length,
          itemBuilder: (context, index) {
            SearchMenuItem currentItem =
                homeController.listOfSearchProjectItem.value[index];
            return InkWell(
              onTap: () {
                Get.toNamed(
                  AppPages.MOBILE_SCREEN,
                  arguments: {
                    'screen': currentItem.screen,
                    'projectId': currentItem.projectId,
                  },
                );
              },
              child: Padding(
                // Se for ultimo index da um espaço maior
                padding: homeController.listOfSearchProjectItem.value.length ==
                        index + 1
                    ? const EdgeInsets.only(bottom: SpacingScale.scaleFour)
                    : const EdgeInsets.all(0),
                child: _createCardProjectScreenItem(
                    currentItem.screen!, currentItem.projectId!),
              ),
            );
          });
    } else {
      return _createCardProjectScreenItem(
          homeController.listOfSearchProjectItem.value[0].screen!,
          homeController.listOfSearchProjectItem.value[0].projectId!);
    }
  }

  Widget _createCardProjectScreenItem(
      ActivatedScreenModel currentScreen, int projectId) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppPages.MOBILE_SCREEN, arguments: {
          'screen': currentScreen,
          'projectId': projectId,
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: SpacingScale.scaleTwo),
        child: MitraCardWidget(
            cardIcon: const Icon(
              Icons.smartphone,
              color: GlobalColors.violet_600,
            ),
            cardIconColor: GlobalColors.violet_50,
            cardTitle: currentScreen.name,
            cardTitleStyle: AppTheme.text_md(AppThemeTextStyleType.medium)),
      ),
    );
  }
}
