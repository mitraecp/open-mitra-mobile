import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/locales/app_translations.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/routes/route_history.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/settings/main_settings.dart';

final RouteHistoryObserver routeHistoryObserver = RouteHistoryObserver();
void main() async {
  //NOTE: Inicializa os comando flutter.
  WidgetsFlutterBinding.ensureInitialized();

  //NOTE: Configurações iniciais.
  await MainSettings.init();

  //NOTE: Força o uso do app em vertical.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //NOTE: Se a linguagem do celular não conter no app, coloca ingles como padrão.
    Locale deviceLocale = globalSupportedLocales.firstWhere(
        (element) => element.toString() == Get.deviceLocale.toString(),
        orElse: () => const Locale('en'));

    // Garantir que a barra de status e navegação estejam visíveis
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge); // Ativa o modo não-fullscreen

    // Definir o estilo da barra de status para que os ícones sejam claros
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Colors.black, // Transparente para que o fundo não seja alterado
      statusBarIconBrightness:
          Brightness.dark, // Ícones claros para barra de status
      statusBarBrightness: Brightness.light, // iOS: Barra de status clara
    ));

    return GetMaterialApp(
      navigatorObservers: [routeHistoryObserver],
      title: "Application",
      initialRoute: AppPages.SPLASH_SCREEN_VIEW,
      // initialBinding: BindingsBuilder(() => {Get.put(AuthProvider())}),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      locale: deviceLocale,
      translationsKeys: AppTranslation.translations,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
