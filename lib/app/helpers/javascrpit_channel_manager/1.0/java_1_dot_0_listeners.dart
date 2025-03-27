import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_mitra_mobile/app/controllers/mobile_screen_controller.dart';
import 'package:open_mitra_mobile/app/controllers/webview_store_controller.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_model.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_flap_model.dart';
import 'package:open_mitra_mobile/app/data/model/iframe_models.dart/iframe_payload_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_bottom_sheet_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_date_picker.dart';
import 'package:open_mitra_mobile/app/helpers/date_time__picker_device_locale.dart';
import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/javascrpit_callbacks.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

final WebViewStore webViewStore = Get.find<WebViewStore>();

class JavaFront1Dot0Listeners {
  setupListenerChannels(WebViewController webViewController) {
    // NOTE: Calls com 1.0

    // Print
    /// Console log do 1.0
    _printMessage(webViewController);

    // Bool que avisa se tem modal aberto no iframe
    /// Gambiarra para tampar header nativo.
    _iframeModalOpen(webViewController);

    // Abrir data picker nativo e chamada para devolver a data selecionada.
    _callModalDatePicker(webViewController);

    // Adapta o mobile pra quando tem um detail aberto
    _iframeDetailBuilderOpen(webViewController);

    // Salva dados da aba atual do detail
    _iframeDetailSaveCurrentFlap(webViewController);

    // Atualiza o nome do detail quando pega de um outro local.
    _setIframeDetailBuilderName(webViewController);

    // Pega os dados do item para mostrar as opções de um item do detail
    _selectedDetailTimelineMenuItem(webViewController);

    _frontCurrentPRVersion(webViewController);

    _callMobileScreenNavigation(webViewController);

    _callMobileToLogoutUser(webViewController);

    _callMobileIframeIsLoading(webViewController);

    _callMobileVerifyToCloseHeader(webViewController);

    _frontValidateIframeResponsive(webViewController);

    _callOpenPhotoLibraryIOS(webViewController);
  }
}

_printMessage(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('Print',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    // ignore: avoid_print
    print(message.message);
  });
}

_iframeModalOpen(
  WebViewController webViewController,
) {
  webViewController.addJavaScriptChannel('iframeModalOpen',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      // O json que vem do message vem todo bugado, entao faço o regExp para arrumar o json da messagem
      String correctedJson = message.message.replaceAllMapped(
          RegExp(r'(\w+):'), (match) => '"${match.group(1)}":');
      Map<String, dynamic> responseData = json.decode(correctedJson);
      mobileController.isModalOnIframeOpen.value = responseData['modalOpen'];
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callModalDatePicker(WebViewController webViewController) {
  bool controlTimerDataPicker = false;

  webViewController.addJavaScriptChannel('callMobileDatePicker',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    try {
      if (controlTimerDataPicker == false) {
        controlTimerDataPicker = true;
        Timer(const Duration(milliseconds: 500), () {
          Map<String, dynamic> data = jsonDecode(message.message);

          String fromCall = data['fromCall'];
          int itemId = data['itemId'];

          DateTime selectedDate;

          if (data['dateSelected'] != null) {
            selectedDate = DateTime.parse(data['dateSelected']);
          } else {
            selectedDate = DateTime.now();
          }

          showMitraDatePicker(
            context: Get.context!,
            currentLocale: helperVerifyDeviceLocale(),
            currentDate: selectedDate,
            isStartDate: false,
            hasToCompare: false,
          ).then((newSelectedDate) {
            String convertData = '';

            if (newSelectedDate != null) {
              //NOTE: Formato para mostrar ao usuario.
              var f = DateFormat('yyyy-MM-dd');
              convertData = f.format(newSelectedDate).toString();

              IframePayloadModel iframePayloadModel = IframePayloadModel(
                messageType: 'DATE-PICKER-FROM-$fromCall',
                messageBody: {'itemId': itemId, 'dateSelected': convertData},
              );

              String jsonPayload = iframePayloadModel.toJson();

              String tempPostMessage = GlobalJavaScriptCall()
                  .webViewPostMessageWithObject(jsonPayload);

              webViewController.runJavaScript(tempPostMessage);
            }
          });

          controlTimerDataPicker = false;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
}

_iframeDetailBuilderOpen(
  WebViewController webViewController,
) {
  bool controlTimerDetail = false;
  webViewController.addJavaScriptChannel('detailBuilder',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      if (controlTimerDetail == false) {
        controlTimerDetail = true;
        Timer(const Duration(milliseconds: 500), () {
          Map<String, dynamic> selectedDetail = jsonDecode(message.message);
          DetailBuilderModel tempDetailModel = DetailBuilderModel(
              name: selectedDetail['detailBuilderName'] ?? '',
              id: selectedDetail['detailBuilderId']);

          mobileController.detailBuilderController.selectedDetailBuilder.value =
              tempDetailModel;

          mobileController.detailBuilderController.getDetailButtonList(
            mobileController.projectController.mergeRefreshToken.value,
          );
          controlTimerDetail = false;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
}

_iframeDetailSaveCurrentFlap(WebViewController webViewController) {
  bool controlTimerDetail = false;
  webViewController.addJavaScriptChannel('saveMobileCurrentDetailFlap',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      if (controlTimerDetail == false) {
        controlTimerDetail = true;
        Timer(const Duration(milliseconds: 500), () {
          Map<String, dynamic> selectedDetail = jsonDecode(message.message);
          DetailFlapModel tempDetailFlapModel = DetailFlapModel(
            name: selectedDetail['flapName'],
            id: selectedDetail['id'],
            canDeleteInfo: selectedDetail['canDeleteInfo'],
          );

          mobileController.detailBuilderController.currentDetailFlap.value =
              tempDetailFlapModel;

          controlTimerDetail = false;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
}

_setIframeDetailBuilderName(WebViewController webViewController) {
  bool controlTimerDetailName = false;
  webViewController.addJavaScriptChannel('detailBuilderName',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      if (controlTimerDetailName == false) {
        controlTimerDetailName = true;
        Timer(const Duration(milliseconds: 500), () {
          String newName = message.message;
          int currentId = mobileController
              .detailBuilderController.selectedDetailBuilder.value.id;

          mobileController.detailBuilderController.selectedDetailBuilder(
              DetailBuilderModel(name: newName, id: currentId));

          controlTimerDetailName = false;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
}

_selectedDetailTimelineMenuItem(WebViewController webViewController) {
  bool controlTimerItemTimelineMenu = false;

  webViewController.addJavaScriptChannel('selectedItemTimelineMenu',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      if (controlTimerItemTimelineMenu == false) {
        controlTimerItemTimelineMenu = true;
        Timer(const Duration(milliseconds: 500), () {
          // Chamo o modal ja com os botões.
          showMitraBottomSheetWidget(
            headerTitle: Text(
              'options'.tr,
              style: AppTheme.text_md(AppThemeTextStyleType.semibold),
            ),
            listOfMitraBottomSheetItem: mobileController.detailBuilderController
                .getListOfMitraBottomSheetItemOfTimelineMenu(),
            bottonSheetHeight: 160.0,
            bottomSheetListGeneratorHeight: 120.0,
            cardIconBackground: Colors.white,
            cardBackground: Colors.white,
            cardBorderColor: GlobalColors.grey_200,
            bottomSheetIsToShowCheckBox: false,
            cardPadding: SpacingScale.scaleOneAndHalf,
            cardIconBackgroundSize: 0.0,
            cardHeight: 55.0,
            onChanged: (int index) {
              mobileController.callExecutegetItemOfTimelineMenu(index);
              Get.back();
            },
          );

          controlTimerItemTimelineMenu = false;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
}

_frontCurrentPRVersion(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('iframeCallBackFrontVersion',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    try {
      final MobileScreenController mobileController =
          Get.find<MobileScreenController>();
      Timer(const Duration(milliseconds: 500), () {
        String frontVersion = message.message;
        mobileController.iframeFrontVersion.value = frontVersion;
      });
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callMobileScreenNavigation(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('callMobileScreenNavigation',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      Map<String, dynamic> data = jsonDecode(message.message);

      mobileController.updateRouteAndSelectedMobileScreen(
        data['screenId'],
        data['name'],
        data['isToUpdateIframeRouteHistory'],
        data['carrySelection'],
      );
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callMobileToLogoutUser(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('callMobileToLogoutUser',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      mobileController.profileController.logout();
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callMobileIframeIsLoading(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('callMobileIframeIsLoading',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      mobileController.preloadingIframe.value = true;
      mobileController.verifyIframeLoading();
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callMobileVerifyToCloseHeader(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('callMobileVerifyToCloseHeader',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      Timer(const Duration(milliseconds: 500), () {
        mobileController.setisToShowHeaderMobileHeaderBar();
      });
    } catch (e) {
      throw Exception(e);
    }
  });
}

_frontValidateIframeResponsive(
  WebViewController webViewController,
) {
  // bool controlTimerDataPicker = false;
  webViewController.addJavaScriptChannel('frontValidateIframeResponsive',
      onMessageReceived: (JavaScriptMessage message) {
    if (!webViewStore.isIframeActive.value) return;
    final MobileScreenController mobileController =
        Get.find<MobileScreenController>();
    try {
      mobileController.onIframeResponseReceived();
    } catch (e) {
      throw Exception(e);
    }
  });
}

_callOpenPhotoLibraryIOS(WebViewController webViewController) {
  webViewController.addJavaScriptChannel('callOpenPhotoLibraryIOS',
      onMessageReceived: (JavaScriptMessage message) async {
    if (!webViewStore.isIframeActive.value) return;
    try {
      // Usando a file_picker para escolher uma imagem
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Tipo de arquivo desejado (imagem)
        allowMultiple: false, // Permitir múltiplas seleções de arquivos
      );

      if (result != null) {
        // Arquivo selecionado
        PlatformFile file = result.files.single;
        final bytes = await File(file.path!).readAsBytes();
        final base64Image = base64Encode(bytes);
        // Caso necessário, você pode enviar o caminho de volta para o WebView ou processar a imagem
        IframePayloadModel iframePayloadModel = IframePayloadModel(
          messageType: 'PROCESS-BASE-IMAGE',
          messageBody: base64Image,
        );

        String jsonPayload = iframePayloadModel.toJson();

        String tempPostMessage =
            GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);

        webViewController.runJavaScript(tempPostMessage);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao selecionar arquivo: $e');
    }
  });
}
