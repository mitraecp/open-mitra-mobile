import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_dimension_contents_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/day_filter_widget.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/multi_select_filter_dialog.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/single_select_filter_dialog.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class BodyFilterListViewWidget extends StatefulWidget {
  final FilterBarController controller;
  const BodyFilterListViewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<BodyFilterListViewWidget> createState() => _BodyFilterListViewWidget();
}

class _BodyFilterListViewWidget extends State<BodyFilterListViewWidget> {
  @override
  Widget build(BuildContext context) {
    //NOTE: Lengh da lista.
    int listLengh =
        widget.controller.filterBarsList.value.filterBarContent?.length ?? 0;
    return Obx(
      (() => widget.controller.mobileScreenController.loadingFilter.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'wait_filter_load'.tr,
                        textStyle: const TextStyle(
                          color: Color.fromRGBO(277, 277, 277, .3),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                        speed: const Duration(milliseconds: 80),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 0),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
              ],
            )
          : ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: RawScrollbar(
                thumbColor: const Color(0xff9D9DB6),
                radius: const Radius.circular(4),
                thumbVisibility: true,
                thickness: 8,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listLengh,
                  itemBuilder: (context, index) {
                    String filterName = '';
                    int filterId = widget.controller.filterBarsList.value
                        .filterBarContent![index].dimensionId!;

                    //NOTE: Verifico se o usuario preencheu o name, caso contrario pego o alias como nome do filtro.
                    widget.controller.filterBarsList.value
                                .filterBarContent![index].alias ==
                            null
                        ? filterName =
                            "${widget.controller.filterBarsList.value.filterBarContent![index].name}"
                        : filterName =
                            "${widget.controller.filterBarsList.value.filterBarContent![index].alias}";

                    //NOTE: Guardo nesta variavel para ficar mais facil de pegar.
                    var tempFilterModel = widget
                        .controller
                        .mobileScreenController
                        .selectedScreen
                        .value
                        .filterBarSelectionsDimensions![index]
                        .obs;
                    tempFilterModel.refresh();
                    //NOTE: DimensionId = 1 equivale ao filtro Dia, neste criamos o calendario.
                    return filterId == globalDayFilterId
                        ? buildDayFilter(context, widget.controller)
                        : _buildDefaultFilter(
                            filterName, index, tempFilterModel, filterId);
                  },
                ),
              ),
            )),
    );
  }

  Widget _buildDefaultFilter(String filterName, int index,
      Rx<FilterBarSelectionsModel> tempFilterModel, int filterId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingScale.scaleTwoAndHalf,
        vertical: SpacingScale.scaleOne,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(filterName,
              style: AppTheme.text_sm(AppThemeTextStyleType.medium).copyWith(
                color: GlobalColors.grey_700,
              )),
          const SizedBox(height: 8),
          Obx(
            (() => InkWell(
                  onTap: () {
                    Get.dialog(
                      //NOTE: Verifico se o filtro é singleSelection.
                      widget.controller.filterBarsList.value
                                  .filterBarContent![index].singleSelection ==
                              true
                          ? SingleSelectFilterDialog(
                              controller: widget.controller,
                              filterName: filterName,
                              dimensionContents:
                                  tempFilterModel.value.dimensionContents!,
                              filterModel: tempFilterModel.value,
                            )
                          : MultiSelectFilterDialog(
                              controller: widget.controller,
                              filterName: filterName,
                              dimensionContents:
                                  tempFilterModel.value.dimensionContents!,
                              filterModel: tempFilterModel.value,
                              filterBarIndex: index,
                            ),
                    ).then((value) async {
                      (context as Element).markNeedsBuild();
                    });
                  },
                  child: tempFilterModel.value.dimensionContents!
                          .every((element) => element.isSelected == false)
                      //NOTE: Se não tiver nenhum item selecionado cria um default label.
                      ? _defaultSelectFilterLabel()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Obx((() => Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.only(
                                      right: 40, left: 4, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: GlobalColors.grey_300,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: tempFilterModel
                                              .value.selectedQuantity <
                                          4
                                      //NOTE: Se tiver menos que quatro itens selecionados, desenho eles na tela.
                                      ? Obx((() => Wrap(
                                            spacing:
                                                _wrapeAdjustForUserDisplay(),
                                            children:
                                                _createTempListBeforeBuild(
                                                    tempFilterModel, index),
                                          )))
                                      //NOTE: Se tiver mais que quatro itens selecionados escrevo um texto com a quantidade
                                      : _buildLabelOfMoreThanOneSelectedItens(
                                          labelText:
                                              '${tempFilterModel.value.selectedQuantity} ${'selected_itens'.tr}',
                                          closeAction: () {
                                            for (var item in tempFilterModel
                                                .value.dimensionContents!) {
                                              item.isSelected = false;
                                            }
                                            (context as Element)
                                                .markNeedsBuild();
                                          },
                                          index: index,
                                        ),
                                ))),
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: SpacingScale.scaleOneAndHalf),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: GlobalColors.grey_500,
                                      size: 22,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _defaultSelectFilterLabel() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: GlobalColors.grey_300,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'select'.tr,
            style: AppTheme.text_md(AppThemeTextStyleType.regular)
                .copyWith(color: GlobalColors.grey_500),
          ),
          const Padding(
            padding: EdgeInsets.only(right: SpacingScale.scaleHalf),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: GlobalColors.grey_500,
            ),
          )
        ],
      ), // Icon(
    );
  }

  double _wrapeAdjustForUserDisplay() {
    switch (globalUserDisplay.name) {
      case 'tablet':
        return 4;
      case 'smallPhone':
        return 8;
      case 'thinPhone':
        return 8;
      case 'proPhone':
        return 3;
      default:
        //NOTE: Case normalPhone;
        return 3;
    }
  }

  List<Widget> _createTempListBeforeBuild(
      Rx<FilterBarSelectionsModel> tempFilterModel, int index) {
    //NOTE: Crio uma lista temporaria que vai receber os itens selecionados.
    var tempList = [];
    for (var e in tempFilterModel.value.dimensionContents!) {
      e.isSelected! ? tempList.add(e) : null;
    }
    return <Widget>[
      //NOTE: Desenho na tela os itens que estão na lista temporaria.
      for (var e in tempList)
        _buildSelectedItens(
          tempFilterModel: tempFilterModel,
          item: e,
          index: index,
        ),
    ];
  }

  Widget _buildSelectedItens(
      {required Rx<FilterBarSelectionsModel> tempFilterModel,
      required FilterDimensionContentsModel item,
      required int index}) {
    return item.isSelected == true
        ? Container(
            height: 32,
            padding: const EdgeInsets.only(left: 8, right: 1),
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: GlobalColors.grey_300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.descr ?? 'null'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.regular),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      color: GlobalColors.grey_900,
                      size: 16,
                    ),
                  ),
                  onTap: () async {
                    widget.controller.haveChange = true;
                    item.isSelected = false;
                    item.tempSelected = false;
                    tempFilterModel.value.listOfDimensionIsOrdered = true;

                    //NOTE: Diminuo a quantidade de selecionados.
                    if (tempFilterModel.value.selectedQuantity != 0) {
                      tempFilterModel.value.selectedQuantity--;
                    }
                    //NOTE: Verifica o selecionar todos.
                    if (tempFilterModel.value.dimensionContents!
                        .every((element) => element.isSelected == true)) {
                      tempFilterModel.value.isAllSelected = true;
                    } else {
                      tempFilterModel.value.isAllSelected = false;
                    }

                    if (tempFilterModel.value.dimensionContents!.length == 1) {
                      item.isSelected = true;
                      tempFilterModel.value.selectedQuantity++;
                      tempFilterModel.value.isAllSelected = true;
                      AppSnackBar().defaultBar('', 'one_dimension_filter'.tr);
                    } else {
                      await widget.controller.removeOneItemToDimension(
                          item, tempFilterModel.value);
                    }

                    widget.controller.verifyHaveValueSelected();
                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildLabelOfMoreThanOneSelectedItens({
    required String labelText,
    required void Function()? closeAction,
    required int index,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 8, right: 1),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
            fontSize: 14,
            color: Color(0xff2C2C42),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
