import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:open_mitra_mobile/app/controllers/mobile_screen_controller.dart';
import 'package:open_mitra_mobile/app/data/model/filter_bar/filter_bar_model.dart';
import 'package:open_mitra_mobile/app/data/model/iframe_models.dart/iframe_payload_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_dimension_contents_model.dart';
import 'package:open_mitra_mobile/app/data/repository/filter_bar_repository/filter_bar_repository.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/selected_date_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/selected_filter_temp_model.dart';
import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/javascrpit_callbacks.dart';

class FilterBarController extends GetxController {
  final FilterBarRepository filterBarRepository = FilterBarRepository();
  Rx<FilterBarModel> filterBarsList = FilterBarModel().obs;
  final MobileScreenController mobileScreenController =
      Get.find<MobileScreenController>();

  DateTime? selectedDate;

  RxBool loading = false.obs,
      loadingDimensionFilter = false.obs,
      isUsingSearch =
          false.obs; // NOTE: Controllar a visibilidade do Marcar todos.

  RxBool isApplingFilter = false.obs;

  Rx<SelectedDateModel> startSelectedDateModel = SelectedDateModel().obs,
      endSelectedDateModel = SelectedDateModel().obs;

  //NOTE: Variavel auxiliar criada para verificação de erro no decorrer da função de applyfilter.
  bool hasError = false, haveChange = false;

  RxString textSearch = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
  }

  //NOTE: Função chamada quando clica no filtro
  Future getFilterBarListById(int filterBarId) async {
    clearDatePickerValues();
    isApplingFilter.value = false;
    filterBarsList = FilterBarModel().obs;
    await filterBarRepository.getFilterBarConfigById(filterBarId).then(
      (data) => {
        //NOTE: Carreguei o filtro pai para pegar informações como id do componente e nome do filtro pai.
        filterBarsList.value = data,
        //NOTE: Carrego os filtros já selecionados e guardo no selecetedFilterItemValue;
        getSelectedFilters(),

        verifyHaveValueSelected(),
      },
      onError: (e) {
        // loading(false);
        throw Exception(e);
      },
    );
    loading(false);
    return filterBarsList.value;
  }

  clearDatePickerValues() {
    startSelectedDateModel = SelectedDateModel().obs;
    endSelectedDateModel = SelectedDateModel().obs;
    selectedDate = null;
  }

  void getSelectedFilters() {
    if (mobileScreenController
            .selectedScreen.value.filterBarSelectionsDimensions !=
        null) {
      for (var item in mobileScreenController
          .selectedScreen.value.filterBarSelectionsDimensions!) {
        //NOTE: A forma de carregar o filtro 'Dia' é diferente, por isso uso esse if.
        if (item.dimensionContents!.first.dimensionId == globalDayFilterId) {
          try {
            verifyStardAndEndDay(item);
            loadDayFilter(item.dimensionContents!);
          } catch (e) {
            throw Exception(e);
          }
        }

        //NOTE: Verifico se aquele item tem algum valor selecionado.
        if (!item.dimensionContents!
            .every((element) => element.isSelected == false)) {
          item.selectedQuantity = 0;
          //NOTE: Busco os itens dentro da lista.
          for (var dimension in item.dimensionContents!) {
            if (dimension.isSelected!) {
              item.selectedQuantity++;
            }
          }
        } else {
          if (item.dimensionContents!.length == 1) {
            item.dimensionContents!.first.isSelected = true;
            item.selectedQuantity++;
          }
          item.isAllSelected = false;
          item.selectedQuantity = 0;
        }
        //NOTE: Se todos forem true, marco o selectAll.
        if (item.dimensionContents!
            .every((element) => element.isSelected == true)) {
          item.isAllSelected = true;
        }
      }
    }
  }

  verifyStardAndEndDay(FilterBarSelectionsModel item) {
    if (item.startDay != null && item.endDay != null) {
      // Primeiro certifico que esta tudo como false.
      for (var itemData in item.dimensionContents!) {
        itemData.isSelected = false;
      }

      // Crio o model de startDay
      FilterDimensionContentsModel startDay = FilterDimensionContentsModel(
        descr: item.startDay,
        dimensionId: globalDayFilterId,
        isSelected: true,
        value: dayFilterFormaterValue(item.startDay!),
      );
      // Seleciono ele
      setStartAndEndDayByTimeOrder(startDay);

      // Crio o model de endDay
      FilterDimensionContentsModel endDay = FilterDimensionContentsModel(
        descr: item.endDay,
        dimensionId: globalDayFilterId,
        isSelected: true,
        value: dayFilterFormaterValue(item.endDay!),
      );
      // Seleciono ele
      setStartAndEndDayByTimeOrder(endDay);
    }
  }

  // Metodo que retorna o formato desejado para o atributo value do FilterDimensionContentsModel
  String dayFilterFormaterValue(String data) {
    // Dividir a string da data em partes (dia, mês, ano)
    List<String> parts = data.split('/');

    // Reorganizar as partes para o formato desejado
    String year = parts[2];
    String mounth = parts[1];
    String day = parts[0];

    // Retornar a string formatada
    return '$year$mounth$day';
  }

  loadDayFilter(List<FilterDimensionContentsModel> dimension) async {
    //NOTE: Verifico se tem valores selecionados, se nao, so passa direto;
    if (!dimension.every((element) => element.isSelected == false)) {
      for (var item in dimension) {
        if (item.isSelected == true) {
          setStartAndEndDayByTimeOrder(item);
          //NOTE: Preciso converter para datetime para fazer o calculo de antes ou depois.
        }
      }
    }
  }

  setStartAndEndDayByTimeOrder(FilterDimensionContentsModel dateModel) {
    var parseDate = DateTime.parse(dateModel.value!);
    if (startSelectedDateModel.value.dateString == null) {
      startSelectedDateModel.value.dateString = dateModel.descr!;
      startSelectedDateModel.value.dateValue = dateModel.value!;
      startSelectedDateModel.value.dateTimeFormat = parseDate;
    } else if (parseDate
        .isBefore(DateTime.parse(startSelectedDateModel.value.dateValue!))) {
      //NOTE: Se vem antes, vou passar meu startDate para o endDate;
      endSelectedDateModel.value.dateString =
          startSelectedDateModel.value.dateString;
      endSelectedDateModel.value.dateValue =
          startSelectedDateModel.value.dateValue;
      endSelectedDateModel.value.dateTimeFormat =
          startSelectedDateModel.value.dateTimeFormat;

      //NOTE: E colocar a nova data que é menor no startDate;
      startSelectedDateModel.value.dateString = dateModel.descr!;
      startSelectedDateModel.value.dateValue = dateModel.value!;
      startSelectedDateModel.value.dateTimeFormat = parseDate;
    } else {
      //NOTE: Se cair nesse else, o valor inicial existe, porem ele é menor, por isso apenos preencho o valor final.
      endSelectedDateModel.value.dateString = dateModel.descr!;
      endSelectedDateModel.value.dateValue = dateModel.value!;
      endSelectedDateModel.value.dateTimeFormat = parseDate;
    }
  }

  cleanAllSelections() {
    haveChange = true;
    clearDatePickerValues();
    //NOTE: Tira o focu do widget, caso tenha.
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    //NOTE: Aqui faço o controle do filtro para ele ficar apagado.
    mobileScreenController.selectedScreen.value.haveValueSelected.value = false;
    //NOTE: Passo todos dimensions para o valor selecionado para falso.
    setToFalseFilterBarSelections();
  }

  setToFalseFilterBarSelections() {
    for (var element in mobileScreenController
        .selectedScreen.value.filterBarSelectionsDimensions!) {
      element.isAllSelected = false;
      element.selectedQuantity = 0;
      for (var item in element.dimensionContents!) {
        item.isSelected = false;
        item.tempSelected = false;
      }
      if (element.dimensionContents!.length == 1) {
        mobileScreenController.selectedScreen.value.haveValueSelected.value =
            true;
        element.dimensionContents!.first.isSelected = true;
        element.dimensionContents!.first.tempSelected = true;
        element.isAllSelected = true;
      }
    }
  }

  Future<void> deleteTempFilters({required int screenId}) async {
    await filterBarRepository.deleteTempFilters(screenId: screenId);
    updateMergeUniversalSource();
    await refreshWebView();
  }

  refreshWebView() async {
    //NOTE: Comando que aciona o java da webview para dar refresh nos componentes.
    mobileScreenController.webViewStore
        .postMessageWebView(GlobalJavaScriptCall().refreshComponents);
  }

  buttonAddFilterValues(List<FilterDimensionContentsModel> dimensionContents,
      FilterBarSelectionsModel filterModel) async {
    SelectedFilterTempModel tempModel = SelectedFilterTempModel();
    tempModel.selectedValue = [];
    //NOTE: Retirar o search.
    if (isUsingSearch.value) {
      await sortSearchFilterList(filterModel: filterModel, textSearch: '');
    }
    filterModel.selectedQuantity = 0;
    for (var i = 0; i < dimensionContents.length; i++) {
      if (dimensionContents[i].tempSelected) {
        dimensionContents[i].isSelected = true;
        tempModel.selectedValue!.add(dimensionContents[i].value!);
        filterModel.tempSearchDimensionContents![i].isSelected = true;
        filterModel.selectedQuantity++;
      } else {
        dimensionContents[i].isSelected = false;
        filterModel.tempSearchDimensionContents![i].isSelected = false;
      }
    }
    if (dimensionContents.every((element) => element.tempSelected == true)) {
      filterModel.isAllSelected = true;
    }
    await updateFilterDimension(
      dimensionId: dimensionContents.first.dimensionId!,
      dimensionValue: tempModel.selectedValue!,
      endDayId: '',
      startDayId: '',
      isApplyFilter: true,
    );

    mobileScreenController.selectedScreen.value.haveValueSelected.value = true;
    haveChange = true;
    filterModel.listOfDimensionIsOrdered = true;
  }

  updateMergeUniversalSource() {
    IframePayloadModel iframePayloadModel = IframePayloadModel(
        messageType: 'toogleSetUniversalSource', messageBody: '');
    String jsonPayload = iframePayloadModel.toJson();
    // print(jsonPayload);
    String tempPostMessage =
        GlobalJavaScriptCall().webViewPostMessageWithObject(jsonPayload);
    mobileScreenController.webViewStore.postMessageWebView(tempPostMessage);
  }

  Future<void> updateFilterDimension({
    required int dimensionId,
    required List<String> dimensionValue,
    required bool isApplyFilter,
    required String startDayId,
    required String endDayId,
  }) async {
    await filterBarRepository.setFilterDimensionContents(
      //NOTE:screenComponentId é o id do componente de filtro.
      screenComponentId: filterBarsList.value.screenComponentId!,
      //NOTE:screenId Id da pagina selecionada.
      screenId: mobileScreenController.selectedScreen.value.id!,
      //NOTE:dimensionId Id da dimensão dentro do filtro.
      dimensionId: dimensionId,
      //NOTE:dimensionValue valor da dimensão dentro do filtro.
      dimensionValue: dimensionValue,
      isApplyFilter: isApplyFilter,
    );
  }

  Future<void> updateDayFilterDimension({
    required int dimensionId,
    required bool isApplyFilter,
    required String startDayId,
    required String endDayId,
  }) async {
    await filterBarRepository.setDayFilterDimensionContents(
      //NOTE:screenComponentId é o id do componente de filtro.
      screenComponentId: filterBarsList.value.screenComponentId!,
      //NOTE:screenId Id da pagina selecionada.
      screenId: mobileScreenController.selectedScreen.value.id!,
      //NOTE:dimensionId Id da dimensão dentro do filtro.
      dimensionId: dimensionId,
      isApplyFilter: isApplyFilter,
      startDayId: startDayId,
      endDayId: endDayId,
    );
  }

  finishApllyFilter() async {
    mobileScreenController.loadingFilter.value = true;
    await mobileScreenController.getScreenFilterBarSelections();
    await refreshWebView();
    mobileScreenController.loadingFilter.value = false;
  }

  refreshComponentsOrder(List<FilterDimensionContentsModel>? dimensionContents,
      FilterBarSelectionsModel filterModel) async {
    loadingDimensionFilter.value = true;
    List<FilterDimensionContentsModel> tempListOfSelected = [];

    //NOTE: Pega os selecionados e guarda em uma lista temporaria.
    for (int i = 0; i < dimensionContents!.length; i++) {
      dimensionContents[i].isSelected!
          ? dimensionContents[i].tempSelected = true
          : dimensionContents[i].tempSelected = false;

      if (dimensionContents[i].isSelected!) {
        tempListOfSelected.add(dimensionContents[i]);
      }
    }

    //NOTE: Aplico no o filtro vazio no banco para pegar a order default da lista.
    await updateFilterDimension(
        dimensionId: dimensionContents.first.dimensionId!,
        dimensionValue: [],
        isApplyFilter: false,
        startDayId: '',
        endDayId: '');

    //NOTE: Faço uma nova busca no banco para reordenar de maneira correta as dimensões.
    await getListOfDimensionContents(filterModel);

    tempListOfSelected.sort((a, b) {
      var firstItemIndex =
          dimensionContents.indexWhere((element) => element.value == a.value);
      var secondItemIndex =
          dimensionContents.indexWhere((element) => element.value == b.value);
      if (firstItemIndex > secondItemIndex) {
        return 1;
      } else {
        return -1;
      }
    });

    for (var item in tempListOfSelected) {
      dimensionContents.removeWhere((element) => element.value == item.value);
      filterModel.tempSearchDimensionContents!
          .removeWhere((element) => element.value == item.value);
    }
    //NOTE: Depois eu adiciono para aparecer em cima.
    dimensionContents.insertAll(0, tempListOfSelected);
    filterModel.tempSearchDimensionContents!.insertAll(0, tempListOfSelected);

    filterModel.listOfDimensionIsOrdered = false;
    loadingDimensionFilter.value = false;
  }

  getListOfDimensionContents(FilterBarSelectionsModel filterModel) async {
    List<FilterBarSelectionsModel> tempList = [];
    int index = -1;
    //NOTE: Nova requisição para pegar os filtros do banco.
    await mobileScreenController.projectController.projectRepository
        .getScreenFilterBarSelections(
            mobileScreenController.selectedScreen.value.id!)
        .then(
          (data) => {
            tempList = data,

            //NOTE: Preencho o temporario somente com a dimensão que estou mexendo no momento.
            index = tempList.indexWhere((element) =>
                element.dimensionContents!.first.dimensionId ==
                filterModel.dimensionContents!.first.dimensionId),

            //NOTE: Comparo com -1 apenas por boa pratica para ver se deu certo a requisição.
            if (index != -1)
              {
                //NOTE: Limpo a anterior;
                filterModel.dimensionContents!.clear(),
                filterModel.tempSearchDimensionContents!.clear(),
                // filterModel = tempList[index],

                // NOTE: Adiciono para pegar a ordem default.
                for (var item in tempList[index].dimensionContents!)
                  {
                    filterModel.dimensionContents!.add(item),
                    filterModel.tempSearchDimensionContents!.add(item),
                  },
              }
          },
        );
  }

  verifyHaveValueSelected() {
    mobileScreenController.selectedScreen.value.filterBarSelectionsDimensions !=
                null &&
            mobileScreenController
                .selectedScreen.value.filterBarSelectionsDimensions!
                .every((element) {
              return element.dimensionContents!.every((dimensionContent) =>
                      dimensionContent.isSelected == false) &&
                  element.startDay == null &&
                  element.endDay == null;
            })
        ? mobileScreenController.selectedScreen.value.haveValueSelected.value =
            false
        : mobileScreenController.selectedScreen.value.haveValueSelected.value =
            true;

    updateMergeUniversalSource();
  }

  cancelAndPopScopeFilter(
      {required List<FilterDimensionContentsModel> dimensionContents,
      required FilterBarSelectionsModel filterModel}) {
    //NOTE: Retirar o search.
    if (isUsingSearch.value) {
      sortSearchFilterList(filterModel: filterModel, textSearch: '');
    }

    filterModel.selectedQuantity = 0;
    for (var i = 0; i < dimensionContents.length; i++) {
      if (dimensionContents[i].isSelected!) {
        dimensionContents[i].tempSelected = true;
        filterModel.tempSearchDimensionContents![i].tempSelected = true;
        filterModel.selectedQuantity++;
      } else {
        dimensionContents[i].tempSelected = false;
        filterModel.tempSearchDimensionContents![i].tempSelected = false;
      }
    }
    if (dimensionContents.every((element) => element.isSelected == true)) {
      filterModel.isAllSelected = true;
    } else {
      filterModel.isAllSelected = false;
    }
  }

  sortSearchFilterList(
      {required FilterBarSelectionsModel filterModel,
      required String textSearch}) async {
    // loadingDimensionFilter.value = true;
    if (textSearch == '') {
      isUsingSearch.value = false;
      if (filterModel.dimensionContents!.length !=
          filterModel.tempSearchDimensionContents!.length) {
        filterModel.dimensionContents!.clear();
        for (var item in filterModel.tempSearchDimensionContents!) {
          filterModel.dimensionContents!.add(item);
        }
      }
    } else {
      //NOTE: Retiro visualmente o marcar todos.
      isUsingSearch.value = true;

      //NOTE: Monto o filtro para mostrar na tela.
      filterModel.dimensionContents!.clear();
      // filterModel.tempSearchDimensionContents!.clear();
      for (var item in filterModel.tempSearchDimensionContents!) {
        item.descr ??= 'null'.tr;
        if (item.descr!.toLowerCase().contains(textSearch.toLowerCase())) {
          filterModel.dimensionContents!.add(item);
        }
      }
      loadingDimensionFilter.value = false;
    }
  }

  apllyDayFilter() async {
    if (startSelectedDateModel.value.dateValue != null &&
        endSelectedDateModel.value.dateValue != null) {
      await updateDayFilterDimension(
          dimensionId: globalDayFilterId,
          isApplyFilter: true,
          startDayId: startSelectedDateModel.value.dateValue!,
          endDayId: endSelectedDateModel.value.dateValue!);
    }
  }

  //NOTE: Verifico se as datas selecionadas sao validas, data inicial vem antes da final, e a final vem depois da inicial;
  bool verifyDate(DateTime newSelectedDate, bool isStartDate) {
    if (isStartDate) {
      if (endSelectedDateModel.value.dateTimeFormat != null) {
        return newSelectedDate
            .isBefore(endSelectedDateModel.value.dateTimeFormat!);
      } else {
        return true;
      }
    } else {
      if (startSelectedDateModel.value.dateTimeFormat != null) {
        return newSelectedDate
            .isAfter(startSelectedDateModel.value.dateTimeFormat!);
      } else {
        return true;
      }
    }
  }

  removeOneItemToDimension(FilterDimensionContentsModel item,
      FilterBarSelectionsModel filterModel) async {
    SelectedFilterTempModel tempModel = SelectedFilterTempModel();
    tempModel.selectedValue = [];
    //NOTE: Retirar o search.
    for (var i = 0; i < filterModel.dimensionContents!.length; i++) {
      if (filterModel.dimensionContents![i].tempSelected) {
        filterModel.dimensionContents![i].isSelected = true;
        tempModel.selectedValue!.add(filterModel.dimensionContents![i].value!);
        filterModel.tempSearchDimensionContents![i].isSelected = true;
      } else {
        filterModel.dimensionContents![i].isSelected = false;
        filterModel.tempSearchDimensionContents![i].isSelected = false;
      }
    }
    await updateFilterDimension(
      dimensionId: item.dimensionId!,
      dimensionValue: tempModel.selectedValue!,
      endDayId: '',
      startDayId: '',
      isApplyFilter: true,
    );
  }
}
