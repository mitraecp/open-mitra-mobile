import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

// ignore: must_be_immutable
class MitraRootHeaderWidget extends StatelessWidget {
  List<Widget>? rootSuffix;
  MitraRootHeaderWidget({this.rootSuffix, Key? key}) : super(key: key);
  HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    Widget userSettings = Padding(
      padding: const EdgeInsets.only(right: SpacingScale.scaleTwoAndHalf),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppPages.PROFILE_PAGE);
        },
        child: _buildUserPhoto(),
      ),
    );

    if (rootSuffix != null) {
      rootSuffix!.add(userSettings);
    }

    return Obx(
      () => controller.homeLoading.value || controller.headerLoading.value
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  Obx(
                    () => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalColors.appPrimary_200),
                      child: _getCardIconWidget(
                          controller
                              .workspaceController.selectWorkspace.value.name,
                          '#5720B7'),
                    ),
                  ),
                  const SizedBox(width: SpacingScale.scaleOne),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Obx(
                              () => Text(
                                appProjectName,
                                style: AppTheme.text_md(
                                    AppThemeTextStyleType.semibold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: SpacingScale.scaleHalf),
                            // const Icon(
                            //   Icons.keyboard_arrow_down_outlined,
                            //   size: 24,
                            // )
                          ],
                        ),
                      ),
                      controller.projectController.selectedProject.value.name !=
                              ''
                          ? SizedBox(
                              child: Obx(
                                () => Text(
                                  controller.projectController.selectedProject
                                      .value.name!,
                                  style: AppTheme.text_sm(
                                          AppThemeTextStyleType.regular)
                                      .copyWith(color: GlobalColors.grey_500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  const Spacer(),
                  rootSuffix != null
                      ? Row(
                          children: rootSuffix!,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              right: SpacingScale.scaleTwoAndHalf),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppPages.PROFILE_PAGE);
                            },
                            child: _buildUserPhoto(),
                          ),
                        ),
                ],
              ),
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
}
