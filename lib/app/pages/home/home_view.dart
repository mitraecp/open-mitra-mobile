import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_loading_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_root_header_widget.dart';
import 'package:open_mitra_mobile/app/pages/home/project_view.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller.initHomeController();
    return Obx(
      () => controller.loadingRootNavigation.value
          ? const Scaffold(
              body: Center(
                child: MitraLoadingWidget(),
              ),
            )
          : Scaffold(
              appBar: MitraAppBar(
                appTitle: MitraRootHeaderWidget(),
                appLeadingWidth: 0,
                appTitleSpacing: 0,
                appLeading: const SizedBox(),
                isToAddOnTopContainer: false.obs,
              ),
              body: SafeArea(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    color: GlobalColors.grey_25,
                    child: Obx(() => controller.homeLoading.value
                        ? const SizedBox()
                        : SizedBox(
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  SpacingScale.scaleTwoAndHalf),
                              child:
                                  // _buildHorizontalLastAccess(controller),
                                  _buildPageView(constraints),
                            ),
                          )),
                  );
                }),
              ),
              // bottomNavigationBar: MitraBottomNavBarWidget(),
            ),
    );
  }

  Widget _buildPageView(BoxConstraints constraints) {
    return controller
            .workspaceController.selectWorkspace.value.projects.isNotEmpty
        ? _buildWorkspaceWithProjects(constraints)
        : _buildEmptyWorkspace();
  }

  Widget _buildEmptyWorkspace() {
    return SizedBox(
      height: Get.height / 1.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/empty_image.svg',
          ),
          const SizedBox(height: SpacingScale.scaleThree),
          Text(
            'space_empty_now'.tr,
            style: AppTheme.text_md(AppThemeTextStyleType.regular).copyWith(
              color: GlobalColors.grey_500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceWithProjects(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: ProjectPage(),
    );
  }
}
