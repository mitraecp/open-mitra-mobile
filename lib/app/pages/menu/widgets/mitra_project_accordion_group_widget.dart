import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_mitra_mobile/app/controllers/menu_page_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/activated_screen.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/project_screen_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_icon_widget.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MitraProjectAccordionGroupWidget extends StatelessWidget {
  final List<ProjectModel> listOfProjects;
  final MenuPageController controller = Get.find();

  MitraProjectAccordionGroupWidget({
    Key? key,
    required this.listOfProjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lista de projetos do workspace
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listOfProjects.length,
          itemBuilder: ((context, index) {
            return Obx(() => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (listOfProjects[index]
                            .accordionListSelected!
                            .value) {
                          listOfProjects[index].accordionListSelected!.value =
                              false;
                        } else {
                          controller.projectController
                              .getAccordionProjectRefreshTokenAndProjectScreenData(
                                  index);
                          controller.workspaceController
                              .setProjectAccordionSelectedIndex(index);
                        }
                      },
                      child: _buildProjectParent(
                        listOfProjects[index],
                      ),
                    ),
                    listOfProjects[index].accordionListSelected!.value
                        ? _buildProjectScreenAccordion(controller, index)
                        : const SizedBox(),
                  ],
                ));
          }),
        ),
      ],
    );
  }

  Widget _buildProjectParent(ProjectModel currentProject) {
    return Container(
      color: currentProject.accordionListSelected?.value ?? false
          ? GlobalColors.grey_50
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SpacingScale.scaleOneAndHalf,
          horizontal: SpacingScale.scaleThree,
        ),
        child: Row(
          children: [
            currentProject.accordionListSelected?.value ?? false
                ? Icon(
                    Icons.arrow_drop_down_rounded,
                    color: GlobalColors.appPrimary_500,
                  )
                : const Icon(
                    Icons.arrow_right_rounded,
                    color: GlobalColors.grey_400,
                  ),
            SizedBox(width: SpacingScale.custom(10)),
            Container(
              height: 24,
              width: 24,
              padding: EdgeInsets.all(SpacingScale.custom(3)),
              decoration: BoxDecoration(
                color:
                    HexColor(currentProject.projectConfig?.color ?? '#7839EE')
                        .withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(4.5)),
              ),
              child: MitraCardIconWidget(
                cardIcon: currentProject.projectConfig != null &&
                        currentProject.projectConfig!.icon != 'initials'
                    ? currentProject.projectConfig!.icon
                    : 'initials',
                cardInitials: currentProject.name ?? '',
                hexColor: currentProject.projectConfig?.color ?? '#7839EE',
                iconSize: 18,
                wordsLength: 2,
              ),
            ),
            SizedBox(width: SpacingScale.custom(10)),
            Text(
              currentProject.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: AppTheme.text_md(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_700),
            ),
            const Spacer(),
            currentProject.accordionListSelected?.value ?? false
                ? InkWell(
                    onTap: () {
                      controller.homeController
                          .goToProjectWithProjectId(currentProject.id, false);
                    },
                    child: Icon(
                      Icons.arrow_forward_outlined,
                      color: GlobalColors.appPrimary_500,
                      size: 24,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildProjectScreenAccordion(
      MenuPageController controller, int currentProjectIndex) {
    final List<ProjectScreenModel> currentProjectScreenModel = controller
        .workspaceController
        .selectWorkspace
        .value
        .projects[currentProjectIndex]
        .accordionProjectScreenList
        .value;

    return Column(
      children: [
        // Lista de Pastas do projeto
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: currentProjectScreenModel.length,
          itemBuilder: ((context, index) {
            return Obx(
              () => Column(
                children: [
                  Container(
                    margin: index == 0
                        ? const EdgeInsets.only(top: SpacingScale.scaleHalf)
                        : const EdgeInsets.only(),
                    color: currentProjectScreenModel[index]
                            .accordionProjectFolderSelected!
                            .value
                        ? GlobalColors.grey_50
                        : Colors.white,
                    child: InkWell(
                      onTap: () {
                        if (currentProjectScreenModel[index]
                            .accordionProjectFolderSelected!
                            .value) {
                          currentProjectScreenModel[index]
                              .accordionProjectFolderSelected!
                              .value = false;
                        } else {
                          controller.projectController
                              .setSelectedAccordionProjectFolder(
                                  currentProjectScreenModel, index);
                        }
                      },
                      child: _buildProjectScreenFolder(
                        currentProjectScreenModel[index],
                      ),
                    ),
                  ),
                  _buildProjectFolderScreensMobile(
                      currentProjectScreenModel[index])
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProjectScreenFolder(
      ProjectScreenModel currentProjectScreenFolder) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingScale.scaleOneAndHalf,
        horizontal: SpacingScale.scaleFive,
      ),
      child: Row(
        children: [
          currentProjectScreenFolder.accordionProjectFolderSelected?.value ??
                  false
              ? Icon(
                  Icons.arrow_drop_down_rounded,
                  color: GlobalColors.appPrimary_500,
                )
              : const Icon(
                  Icons.arrow_right_rounded,
                  color: GlobalColors.grey_400,
                ),
          SizedBox(width: SpacingScale.custom(10)),
          const Icon(
            Icons.folder_outlined,
            color: GlobalColors.grey_500,
            size: 24,
          ),
          SizedBox(width: SpacingScale.custom(10)),
          SizedBox(
            width: Get.height / 4,
            child: currentProjectScreenFolder.activatedScreens != null &&
                    currentProjectScreenFolder.activatedScreens!.isNotEmpty
                ? Text(
                    currentProjectScreenFolder.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text_md(AppThemeTextStyleType.regular)
                        .copyWith(color: GlobalColors.grey_700),
                  )
                : Text(
                    '${currentProjectScreenFolder.name} ${'no_mobile_screen'.tr}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text_md(AppThemeTextStyleType.regular)
                        .copyWith(color: GlobalColors.grey_400),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildProjectFolderScreensMobile(
      ProjectScreenModel currentProjectFolder) {
    return currentProjectFolder.activatedScreens != null
        ? currentProjectFolder.activatedScreens!.isNotEmpty &&
                currentProjectFolder.accordionProjectFolderSelected!.value
            ? _buildMobileScreens(
                currentProjectFolder.activatedScreens!, currentProjectFolder.id)
            : const SizedBox()
        : const SizedBox();
  }

  Widget _buildMobileScreens(
      List<ActivatedScreenModel> mobileScreens, int projectId) {
    return Column(
      children: [
        // Lista telas mobiles
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mobileScreens.length,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(
                  AppPages.MOBILE_SCREEN,
                  arguments: {
                    'screen': mobileScreens[index],
                    'projectId': projectId
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SpacingScale.scaleOneAndHalf,
                  horizontal: SpacingScale.custom(60),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalColors.grey_400,
                      ),
                    ),
                    SizedBox(width: SpacingScale.custom(10)),
                    Text(
                      mobileScreens[index].name,
                      style: AppTheme.text_md(AppThemeTextStyleType.regular)
                          .copyWith(color: GlobalColors.grey_700),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
