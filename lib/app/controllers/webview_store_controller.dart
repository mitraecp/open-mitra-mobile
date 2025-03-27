import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/javascript_listeners.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;

class WebViewStore extends GetxController {
  WebViewController webViewController = WebViewController();

  bool _isJavaScriptChannelsConfigured =
      false; // Flag para verificar se os canais foram configurados
  bool webViewCreated = false;

  RxString currentUrl = ''.obs;
  RxBool isToShowWebView = false.obs, webViewLoading = false.obs;

  RxString iframeLeaveMitraSiteName = ''.obs;

  RxBool isIframeActive = false.obs;

  reloadWebView(String url) {
    webViewController.loadRequest(Uri.parse(url));
  }

  changeCurrentUrl(String url) {
    currentUrl.value = url;
    webViewController.loadRequest(Uri.parse(url));
    webViewLoading.value = true;
  }

  clearCache() {
    webViewController.clearCache();
  }

  postMessageWebView(String message) {
    webViewController.runJavaScript(message);
  }

  initWebViewController() {
    currentUrl.value = getGlobalFront1_0Url();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params);
// ···
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    startWebView();
    webViewCreated = true;
  }

  startWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return iframeNavigationRequestRules(request);
          },
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            webViewLoading.value = true;
          },
          onPageFinished: (String url) {
            webViewLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(currentUrl.value));

    if (Platform.isAndroid) {
      final myAndroidController = webViewController.platform
          as webview_flutter_android.AndroidWebViewController;

      myAndroidController.setOnShowFileSelector(_androidFilePicker);
    }

    setJavaScriptChannelManager();
  }

  Future<List<String>> _androidFilePicker(
      webview_flutter_android.FileSelectorParams params) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      // Convert the file to base64
      List<int> fileBytes = await File(filePath).readAsBytes();

      //convert filepath into uri
      final filePath1 = (await getCacheDirectory()).uri.resolve(fileName);
      final file = await File.fromUri(filePath1).create(recursive: true);

      //convert file in bytes
      await file.writeAsBytes(fileBytes, flush: true);

      return [file.uri.toString()];
    }

    return [];
  }

  Future<Directory> getCacheDirectory() async {
    // Obtém o diretório de cache do aplicativo
    final directory = await getTemporaryDirectory();
    return directory;
  }

  setJavaScriptChannelManager() {
    if (!_isJavaScriptChannelsConfigured) {
      // Classe com as comunicações com o java.
      JavaScriptChannelManager().setup1Dot0ListenerChannels(webViewController);
      _isJavaScriptChannelsConfigured = true;
    } else {
      // ignore: avoid_print
      print('Os canais de comunicação já foram configurados.');
    }
  }

  NavigationDecision iframeNavigationRequestRules(NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/watch') ||
        request.url.startsWith('https://m.youtube.com/watch')) {
      // caso youtube
      iframeLeaveMitraSiteName.value = 'YouTube';
      return NavigationDecision.navigate;
    } else if (request.url.startsWith('https://wa.me') ||
        request.url.startsWith('whatsapp://')) {
      iframeLeaveMitraSiteName.value = '';
      // Caso whatsapp
      _launchURL(request.url);
      return NavigationDecision.prevent;
    } else {
      if (request.url != ('about:blank')) {
        iframeLeaveMitraSiteName.value = '';
      }
      return NavigationDecision.navigate;
    }
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // ignore: avoid_print
      print("Erro ao abrir $url");
    }
  }
}
