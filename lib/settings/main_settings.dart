import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';

class MainSettings {
  static init() async {
    //NOTE: Inicializa o firebase.
    //Login com firebase.
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );

    // Note: Verifica se o usuario esta usando IOS.
    if (Platform.isIOS) {
      userSystemIsIOS = true;
    }

    //NOTE: Versões mais antigas do android precisam de adicionar uma licença para realizar o http request.
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      if (sdkInt <= globalMinimumSdk) {
        ByteData data =
            await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
        SecurityContext.defaultContext
            .setTrustedCertificatesBytes(data.buffer.asUint8List());
      }
    }

    //NOTE: Inicializa o storage local.
    await GetStorage.init();
  }
}
