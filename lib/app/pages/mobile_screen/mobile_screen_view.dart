import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/mobile_screen_controller.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_bottom_sheet_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_loading_widget.dart';
import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/javascrpit_callbacks.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/show_filter_bottom_sheet.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MobileScreenView extends StatefulWidget {
  const MobileScreenView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MobileScreenViewState createState() => _MobileScreenViewState();
}

class _MobileScreenViewState extends State<MobileScreenView>
    with WidgetsBindingObserver {
  final MobileScreenController controller = Get.find<MobileScreenController>();
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    controller.initController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App entrou em background (stand by)
      _backgroundTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App voltou para o foreground
      _checkBackgroundDuration();
    }
  }

  void _checkBackgroundDuration() {
    if (_backgroundTime != null) {
      final duration = DateTime.now().difference(_backgroundTime!);
      if (duration.inMinutes >= 5) {
        controller.verifyIframeIsResponsive();
      }
      _backgroundTime =
          null; // Reset para a próxima vez que o app entrar em background
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          controller.detailBuilderController.selectedDetailBuilder.value.id ==
              -1,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (controller.detailBuilderController.selectedDetailBuilder.value.id !=
            -1) {
          controller.mobileScreenCanPop(false);
          controller.closeCurrentDetail();
        } else {
          controller.mobileScreenCanPop(true);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: Platform.isAndroid,
        appBar: _buildMobileHeader(context),
        body: SizedBox(
          child: SafeArea(
            top: true,
            bottom: true,
            child: _buildWebView(controller, context),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMobileHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () => AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 100), // Defina a duração da animação
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Aplica o fade e move o widget para cima durante a transição
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.2), // Começa ligeiramente acima
                end: Offset.zero, // Termina na posição normal
              ).animate(animation),
              child: FadeTransition(
                opacity: animation, // Efeito fade
                child: child,
              ),
            );
          },
          child: !controller.isToShowHeaderMobileHeaderBar.value &&
                  controller.detailBuilderController.selectedDetailBuilder.value
                          .id ==
                      -1
              ? const SizedBox(
                  height: 50,
                ) // Widget que será trocado
              : MitraAppBar(
                  key: ValueKey<bool>(controller.isToShowHeaderMobileHeaderBar
                      .value), // Define a key para diferenciar os widgets
                  appTitle: Obx(
                    () => controller.loadingHeader.value
                        ? const SizedBox()
                        : !controller.isToShowHeaderMobileHeaderBar.value &&
                                controller.detailBuilderController
                                        .selectedDetailBuilder.value.id ==
                                    -1
                            ? const Text('')
                            : Text(
                                controller.detailBuilderController
                                            .selectedDetailBuilder.value.id !=
                                        -1
                                    ? controller.detailBuilderController
                                        .selectedDetailBuilder.value.name
                                    : controller
                                        .selectedMobileScreen.value.name,
                                style: AppTheme.text_lg(
                                    AppThemeTextStyleType.semibold),
                              ),
                  ),
                  appLeading: Padding(
                    padding: const EdgeInsets.only(
                        left: SpacingScale.scaleOneAndHalf),
                    child: IconButton(
                      onPressed: () {
                        if (controller.detailBuilderController
                                .selectedDetailBuilder.value.id !=
                            -1) {
                          controller.closeCurrentDetail();
                        } else {
                          if (!controller.isLastHistoryOfSelectedScreen()) {
                            controller.goBackHistory();
                          } else {
                            controller.disposeSelectedMobileScreen();
                            Get.back();
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_left_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  isToAddOnTopContainer: controller.isModalOnIframeOpen,
                  appAction: _buildSuffixRuleFilterIcon(),
                ),
        ),
      ),
    );
  }

  Widget _buildWebView(
      MobileScreenController controller, BuildContext context) {
    return Obx(
      () => !controller.loadingMobileScreen.value &&
              !controller.homeController.loadingRootNavigation.value
          ? Container(
              constraints: BoxConstraints(
                minHeight: controller.homeController.iframeMaxHeigth.value,
              ),
              child: Stack(
                children: [
                  WebViewWidget(
                      controller: controller.webViewStore.webViewController),
                  // WebviewPageBuilderView(
                  //   screenId: controller.selectedMobileScreen.value.id,
                  //   url: controller.getWebUrl(),
                  // ),
                  Obx(
                    (() => !controller.showWebViewIframe.value
                        ? Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            height: Get.height,
                            width: Get.width,
                            child: Center(
                              // Primeira animação do texto.
                              child: !controller.loadAnimetedText.value
                                  ? AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          // 'loading_page'.tr,
                                          controller.iframeLoadingText.value,
                                          textStyle: const TextStyle(
                                            color: Color.fromRGBO(
                                                277, 277, 277, .3),
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 80),
                                        ),
                                      ],
                                      totalRepeatCount: 1,
                                      pause: const Duration(milliseconds: 0),
                                      displayFullTextOnTap: true,
                                      stopPauseOnTap: true,
                                      onFinished: () {
                                        controller.loadAnimetedText.value =
                                            true;
                                        // Se for master eu so removo o tapume do loading
                                        if (currentBaseUrlNameUrl.value ==
                                            'master') {
                                          controller.showWebViewIframe.value =
                                              true;
                                        }
                                      },
                                    )
                                  // Atualizo o texto para ver qual o estado ja carregou.
                                  // 1 ponto carregou o iframe
                                  // 2 ponto carregou o front iniciou o preloading
                                  : Text(
                                      controller.iframeLoadingText.value,
                                      style: const TextStyle(
                                        color:
                                            Color.fromRGBO(277, 277, 277, .3),
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ),
                          )
                        : const SizedBox()),
                  ),
                ],
              ),
            )
          : const Center(
              child: MitraLoadingWidget(),
            ),
    );
  }

  List<Widget> _buildSuffixRuleFilterIcon() {
    return [
      Obx(
        () =>
            controller.detailBuilderController.selectedDetailBuilder.value.id !=
                    -1
                ? Row(
                    children: _buildSuffixOfDetailBuilder(),
                  )
                : Row(children: _buildSuffixOfMainPage()),
      ),
    ];
  }

  List<Widget> _buildSuffixOfDetailBuilder() {
    return [
      Obx(
        () => (controller.detailBuilderController
                .selectedDetailButtonsWithTopFlag.value.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.only(right: SpacingScale.scaleOneAndHalf),
                child: IconButton(
                  onPressed: () async {
                    // Crio a lista de bottões.
                    await controller.getListOfMitraBottomSheetItem();

                    // Chamo o modal ja com os botões.
                    showMitraBottomSheetWidget(
                      headerTitle: _buildHeaderOfBottomSheetWidget(),
                      listOfMitraBottomSheetItem:
                          controller.tempDetailButtonList.value,
                      cardIconBackground: Colors.white,
                      cardBackground: Colors.white,
                      cardBorderColor: GlobalColors.grey_200,
                      bottomSheetIsToShowCheckBox: false,
                      cardPadding: SpacingScale.scaleOneAndHalf,
                      cardIconBackgroundSize: 0.0,
                      onChanged: (int index) {
                        controller.callExecuteDetailButtonOnIframe(index);
                        Get.back();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_horiz_outlined,
                    color: GlobalColors.grey_700,
                    size: 24,
                  ),
                ),
              )
            : const SizedBox()),
      )
    ];
  }

  Widget _buildHeaderOfBottomSheetWidget() {
    return Text(
      'options'.tr,
      style: AppTheme.text_md(AppThemeTextStyleType.semibold),
    );
  }

  List<Widget> _buildSuffixOfMainPage() {
    return [
      // Save data entry Refatorar + testar
      Obx(
        () => controller.dataEntryActive.value
            ? Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  onPressed: () async {
                    await controller.webViewStore.postMessageWebView(
                        GlobalJavaScriptCall().saveDataEntryScript);
                    controller.dataEntryActive.value = false;
                  },
                  icon: const Icon(
                    Icons.save,
                    size: 22,
                  ),
                ),
              )
            : const SizedBox(),
      ),

      // Reload do webview, testar + refatatorar (tentrar trocar por puxa pra baixo agora q nao tem stack)
      Obx(() => controller.webViewLoading.value
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: controller.reloadModule,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/refresh.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
              // child: IconButton(
              //   onPressed: controller.reloadModule,
              //   icon: const Icon(
              //     Icons.refresh,
              //     color: GlobalColors.grey_700,
              //     size: 24,
              //   ),
              // ),
            )),

      // Icone do filtro.
      Obx(
        () => controller.webViewLoading.value
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Obx(
                  () => controller.selectedScreen.value.filterBarId != null
                      ? InkWell(
                          onTap: () {
                            controller.loading.isTrue
                                ? null
                                : showFilterBottomSheet(controller);
                          },
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/filter.svg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
      ),

      // Icone HOME
      Obx(() => controller.webViewLoading.value ||
              controller.historyRouteMobileOnHome.value
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: controller.goRouteHome,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Center(
                    child: SvgPicture.asset('assets/svg/home.svg',
                        height: 24, width: 24, fit: BoxFit.contain),
                  ),
                ),
              ),
            )),
    ];
  }
}
