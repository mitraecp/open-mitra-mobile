import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/base_url_mitra_model.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/current_user_model.dart';

// NOTE: User SO.
bool userSystemIsIOS = false;
String emptyLogoUrl =
    'https://firebasestorage.googleapis.com/v0/b/mitra-app-f019a.appspot.com/o/marketplace_images%2Fempty_logo.jpg?alt=media&token=b154b883-9799-44a6-9978-bdc9db9d3b02';
RxList<BaseUrlMitraModel> globalBaseUrlLinks = RxList<BaseUrlMitraModel>([]);
RxString currentBaseUrlLink = ''.obs;
RxString currentBaseUrlNameUrl = ''.obs;

String global1_0FrontUrl = 'https://mergerelease.mitralab.io';

String getGlobalFront1_0Url() {
  try {
    return global1Dot0FrontUrlLinks
        .firstWhere((element) => element.name == currentBaseUrlNameUrl.value)
        .link;
  } catch (e) {
    return global1Dot0FrontUrlLinks
        .firstWhere((element) => element.name == 'master')
        .link;
  }
}

// URL 1.0
RxList<BaseUrlMitraModel> global1Dot0FrontUrlLinks =
    RxList<BaseUrlMitraModel>([]);
// URL 2.0
RxList<BaseUrlMitraModel> globalAiFrontUrlLinks = RxList<BaseUrlMitraModel>([]);

String getGlobalFront2_0Url() {
  try {
    return globalAiFrontUrlLinks
        .firstWhere((element) => element.name == currentBaseUrlNameUrl.value)
        .link;
  } catch (e) {
    return globalAiFrontUrlLinks
        .firstWhere((element) => element.name == 'master')
        .link;
  }
}

// NOTE: Verifico se o app esta no modo build ou no modo debugging para retornar o front certo.
String getGlobalBaseUrl() {
  return currentBaseUrlLink.value;
}

//NOTE: Link para o termo de uso.
String globalUriTermsOfUse =
    'https://minutas.mitraecp.com/artigos/termos-de-uso-e-politica-de-privacidade/';

//NOTE: E-mail de suporte
String globalSuporteEmail = 'suporte@mitraecp.com.';
//NOTE: Dados do usuario logado no momento.
CurrentUserModel? globalCurrentUser = CurrentUserModel();

GlobalUserDisplay globalUserDisplay = GlobalUserDisplay.normalPhone;

//NOTE: O valor atual do filtro 'Dia' no BD;
int globalDayFilterId = 1;
//NOTE: O valor atual do filtro 'Mês' no BD;
int globalMonthFilterId = 2;

//NOTE: Minimo sdk do android para pegar a licença de http request.
int globalMinimumSdk = 24;

//NOTE: Versão do aplicativo;
String? globalAppVersion;

//NOTE: Versão do aplicativo;
double? globalDisplayHeight;

int menuBottomBarIndex = 0,
    homeBottomBarIndex = 1,
    searchBottomBarIndex = 2;

int homePageProjectIndex = 0, homePageFolderIndex = 1, homePageScreenIndex = 2;

enum GlobalUserDisplay {
  tablet, //NOTE: width maior que 800.
  smallPhone, //NOTE: x width por até 799 height
  thinPhone, //NOTE: width menor que 375 e height maior  ou igual a 800
  proPhone, //NOTE: width maior que 375 e height maior que 880.
  normalPhone, //NOTE: width maior que 375 e height menor que 880.
  // macOS,
  // winodws,
  // linux,
}

List<Locale> globalSupportedLocales = [
  const Locale('en'),
  const Locale('pt_BR'),
  const Locale('pt'),
];

List<String> globalEmailSuporteApp = [
  'wayner@mitraecp.com',
  'vitor.almeida@mitraecp.com',
  'igor@mitraecp.com',
  'joao.silvestre@mitraecp.com'
];

List<String> globalTipsOfUsage = [
  // 'drill_tip',
  'loading_page',
];
