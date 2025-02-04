import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_bar_selections_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/filter_dimension_contents_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_checkbox_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/search_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MultiSelectFilterDialog extends StatefulWidget {
  final FilterBarController controller;
  final String filterName;
  final List<FilterDimensionContentsModel>? dimensionContents;
  final FilterBarSelectionsModel filterModel;
  final int filterBarIndex;

  const MultiSelectFilterDialog({
    Key? key,
    required this.controller,
    required this.filterName,
    required this.dimensionContents,
    required this.filterModel,
    required this.filterBarIndex,
  }) : super(key: key);

  @override
  State<MultiSelectFilterDialog> createState() => _MultiSelectFilterDialog();
}

class _MultiSelectFilterDialog extends State<MultiSelectFilterDialog> {
  // String searchValue = '';
  List<FilterDimensionContentsModel> selecetedFilterItemValue = [];

  @override
  void initState() {
    super.initState();
    //NOTE: Entra nesse if se houve mudanças.
    if (widget.filterModel.listOfDimensionIsOrdered) {
      if (widget.filterModel.selectedQuantity < 50 &&
          !widget.filterModel.isAllSelected) {
        widget.controller.refreshComponentsOrder(
            widget.dimensionContents!, widget.filterModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.controller.cancelAndPopScopeFilter(
          dimensionContents: widget.dimensionContents!,
          filterModel: widget.filterModel,
        );
        return true;
      },
      child: Builder(
        builder: (contextDialog) => Dialog(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
            height: Get.height,
            child: Column(
              children: [
                _titleWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: SpacingScale.scaleThree),
                  child: SearchWidget(
                    hintText: 'filter_search'.tr,
                    onTapAction: () {
                      widget.controller.isUsingSearch.value = false;
                    },
                    onChanged: (value) {
                      widget.controller.textSearch.value = value;
                      widget.controller
                          .sortSearchFilterList(
                              filterModel: widget.filterModel,
                              textSearch: value)
                          .then((_) {
                        (contextDialog as Element).markNeedsBuild();
                      });
                    },
                  ),
                ),
                Obx(
                  (() {
                    return !widget.controller.loadingDimensionFilter.value
                        ? _bodyWidget(contextDialog, widget.dimensionContents!)
                        : const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  }),
                ),
                const MitraDividerWidget(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.filterName,
          style: AppTheme.text_md(AppThemeTextStyleType.semibold),
        ),
        InkWell(
          onTap: () {
            widget.controller.cancelAndPopScopeFilter(
              dimensionContents: widget.dimensionContents!,
              filterModel: widget.filterModel,
            );
            Get.back();
          },
          child: const Icon(
            Icons.close,
            size: 20,
            color: GlobalColors.grey_500,
          ),
        )
      ],
    );
  }

  Widget _bodyWidget(BuildContext contextDialog,
      List<FilterDimensionContentsModel>? dimensionContents) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: RawScrollbar(
          thumbColor: const Color(0xff9D9DB6),
          radius: const Radius.circular(4),
          thumbVisibility: true,
          thickness: 8,
          interactive: dimensionContents!.length < 1000,
          child: ListView.builder(
            shrinkWrap: true,
            // physics: const ScrollPhysics(),
            itemCount: widget.dimensionContents!.length + 1,
            itemBuilder: ((context, index) {
              // String str = widget.dimensionContents![index].descr!;
              // if (str.toLowerCase().contains(searchValue.toLowerCase())) {
              if (index == 0) {
                return !widget.controller.loadingDimensionFilter.value &&
                        !widget.controller.isUsingSearch.value
                    ? _tagAllWidget(contextDialog)
                    : Container();
              } else {
                //NOTE: O Index zero se refere ao selecionar todos,
                //por isso eu sempre puxo index -1 do widget para pegar a casa zero do dimensionContents.
                return Container(
                  margin: const EdgeInsets.only(top: SpacingScale.scaleOne),
                  padding: EdgeInsets.symmetric(
                    vertical: SpacingScale.scaleOneAndHalf,
                    horizontal: SpacingScale.custom(14),
                  ),
                  decoration: const BoxDecoration(
                    color: GlobalColors.grey_25,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      bool value =
                          !widget.dimensionContents![index - 1].tempSelected;
                      if (!value) {
                        widget.dimensionContents![index - 1].tempSelected =
                            false;
                        if (widget.filterModel.isAllSelected) {
                          widget.filterModel.isAllSelected = false;
                        }
                      } else {
                        //NOTE: Aplico a seleção.
                        widget.dimensionContents![index - 1].tempSelected =
                            true;

                        //NOTE: Para verificar o marcar todos, primeiro preciso ver se o search esta sendo usado.
                        if (widget.controller.isUsingSearch.value) {
                          //NOTE: Retirar o search.
                          await widget.controller.sortSearchFilterList(
                              filterModel: widget.filterModel, textSearch: '');

                          if (widget.dimensionContents!.every(
                              (element) => element.tempSelected == true)) {
                            widget.filterModel.isAllSelected = true;
                          }

                          //NOTE: Retorno ao filtro de altes.
                          await widget.controller.sortSearchFilterList(
                              filterModel: widget.filterModel,
                              textSearch: widget.controller.textSearch.value);
                        } else {
                          if (widget.dimensionContents!.every(
                              (element) => element.tempSelected == true)) {
                            widget.filterModel.isAllSelected = true;
                          }
                        }
                      }
                      (contextDialog as Element).markNeedsBuild();
                    },
                    child: Row(
                      children: [
                        MitraCheckboxWidget(
                          checkboxTypeEnum:
                              MitraCheckboxTypeEnum.rectangleWithCheck,
                          isChecked:
                              widget.dimensionContents![index - 1].tempSelected,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: SpacingScale.scaleOneAndHalf),
                          child: Text(
                            dimensionContents[index - 1].descr ?? 'null'.tr,
                            style:
                                AppTheme.text_sm(AppThemeTextStyleType.medium),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _tagAllWidget(BuildContext contextDialog) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
              top: SpacingScale.scaleTwo, bottom: SpacingScale.scaleOneAndHalf),
          padding: EdgeInsets.symmetric(
            vertical: SpacingScale.scaleOneAndHalf,
            horizontal: SpacingScale.custom(14),
          ),
          decoration: const BoxDecoration(
            color: GlobalColors.grey_25,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: InkWell(
            onTap: () {
              var value = !widget.filterModel.isAllSelected;
              if (!value) {
                widget.filterModel.isAllSelected = false;
                widget.filterModel.selectedQuantity = 0;
                for (var i = 0; i < widget.dimensionContents!.length; i++) {
                  widget.dimensionContents![i].tempSelected = false;
                  widget.filterModel.tempSearchDimensionContents![i]
                      .tempSelected = false;
                  widget.filterModel.selectedQuantity++;
                }
              } else {
                widget.filterModel.selectedQuantity = 0;
                widget.filterModel.isAllSelected = true;
                for (var i = 0; i < widget.dimensionContents!.length; i++) {
                  widget.dimensionContents![i].tempSelected = true;
                  widget.filterModel.tempSearchDimensionContents![i]
                      .tempSelected = true;
                  widget.filterModel.selectedQuantity++;
                }
              }
              (contextDialog as Element).markNeedsBuild();
            },
            child: Row(
              children: [
                MitraCheckboxWidget(
                  checkboxTypeEnum: MitraCheckboxTypeEnum.rectangleWithCheck,
                  isChecked: widget.filterModel.isAllSelected,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
                  child: Text(
                    'tag_all'.tr,
                    style: AppTheme.text_sm(AppThemeTextStyleType.medium),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: SpacingScale.scaleOneAndHalf),
          child: MitraDividerWidget(),
        )
      ],
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SpacingScale.scaleTwo),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AppButtonWidget(
              style: AppButtonStyle.outlined,
              child: Text(
                'button_cancel'.tr,
                style: AppTheme.text_md(AppThemeTextStyleType.medium)
                    .copyWith(color: GlobalColors.grey_700),
              ),
              onPressed: () {
                widget.controller.cancelAndPopScopeFilter(
                  dimensionContents: widget.dimensionContents!,
                  filterModel: widget.filterModel,
                );
                Get.back();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButtonWidget(
              style: AppButtonStyle.contained,
              onPressed: () {
                widget.controller
                    .buttonAddFilterValues(
                  widget.dimensionContents!,
                  widget.filterModel,
                )
                    .then((_) async {
                  Get.back();
                });
              },
              // disableButtonColor: controller.disableButtonColor.value,
              child: Text(
                'button_add'.tr,
                style: AppTheme.text_md(AppThemeTextStyleType.medium)
                    .copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}