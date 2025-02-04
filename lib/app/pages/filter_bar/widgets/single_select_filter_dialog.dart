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

class SingleSelectFilterDialog extends StatefulWidget {
  final FilterBarController controller;
  final String filterName;
  final List<FilterDimensionContentsModel>? dimensionContents;
  final FilterBarSelectionsModel filterModel;

  const SingleSelectFilterDialog({
    Key? key,
    required this.controller,
    required this.filterName,
    required this.dimensionContents,
    required this.filterModel,
  }) : super(key: key);

  @override
  State<SingleSelectFilterDialog> createState() => _SingleSelectFilterDialog();
}

class _SingleSelectFilterDialog extends State<SingleSelectFilterDialog> {
  String searchValue = '';
  List<FilterDimensionContentsModel> selecetedFilterItemValue = [];

  @override
  void initState() {
    super.initState();
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
    for (var item in widget.dimensionContents!) {
      if (item.tempSelected) {
        selecetedFilterItemValue.add(item);
      }
    }

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
                borderRadius: BorderRadius.all(Radius.circular(8))),
            height: Get.height,
            padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleWidget(),
                const SizedBox(height: SpacingScale.scaleThree),
                SearchWidget(
                  hintText: 'filter_search'.tr,
                  onChanged: (value) {
                    widget.controller.textSearch.value = value;
                    widget.controller
                        .sortSearchFilterList(
                            filterModel: widget.filterModel, textSearch: value)
                        .then((_) {
                      (contextDialog as Element).markNeedsBuild();
                    });
                  },
                ),
                Obx(
                  (() {
                    return !widget.controller.loadingDimensionFilter.value
                        ? _bodyWidget(contextDialog)
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

  Widget _bodyWidget(BuildContext contextDialog) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: RawScrollbar(
          thumbColor: const Color(0xff9D9DB6),
          radius: const Radius.circular(4),
          thumbVisibility: true,
          thickness: 8,
          child: Padding(
            padding: const EdgeInsets.only(top: SpacingScale.scaleTwo),
            child: ListView.builder(
              shrinkWrap: true,
              // physics: const ScrollPhysics(),
              itemCount: widget.dimensionContents!.length,
              itemBuilder: ((context, index) {
                // String str = widget.dimensionContents![index].descr!;
                // if (str.toLowerCase().contains(searchValue.toLowerCase())) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: widget.dimensionContents![index].descr!.length < 30
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: InkWell(
                    onTap: () async {
                      //NOTE: Guardo para referencia o item clicado.
                      FilterDimensionContentsModel tempDimension =
                          widget.dimensionContents![index];

                      //NOTE: Se o search tiver sendo usado.
                      if (widget.controller.isUsingSearch.value) {
                        //NOTE: Retirar o search.
                        await widget.controller.sortSearchFilterList(
                            filterModel: widget.filterModel, textSearch: '');
                        //NOTE: Se todos forem falso apenas marco o item.
                        if (widget.dimensionContents!.every(
                            (element) => element.tempSelected == false)) {
                          //NOTE: Procuro o index pelo tempDimension e marco ele.
                          widget
                              .dimensionContents![widget.dimensionContents!
                                  .indexWhere(
                                      (element) => element == tempDimension)]
                              .tempSelected = true;
                        } else {
                          //NOTE: Se entrar neste else tem pelo menos um item selecionado.
                          //portando desmarco todos os itens.
                          for (var item in widget.dimensionContents!) {
                            item.tempSelected = false;
                          }
                          //NOTE: Procuro o index pelo tempDimension e marco ele.
                          widget
                              .dimensionContents![widget.dimensionContents!
                                  .indexWhere(
                                      (element) => element == tempDimension)]
                              .tempSelected = true;
                        }
                        await widget.controller.sortSearchFilterList(
                            filterModel: widget.filterModel,
                            textSearch: widget.controller.textSearch.value);
                      } else {
                        //NOTE: Se não tiver usando o search.
                        if (widget.dimensionContents!.every(
                            (element) => element.tempSelected == false)) {
                          widget.dimensionContents![index].tempSelected = true;
                        } else {
                          for (var item in widget.dimensionContents!) {
                            item.tempSelected = false;
                          }
                          widget.dimensionContents![index].tempSelected = true;
                        }
                      }

                      // else if (widget.dimensionContents![index].isSelected!) {
                      //   widget.dimensionContents![index].isSelected = false;
                      // }
                      (contextDialog as Element).markNeedsBuild();
                      // (context as Element).markNeedsBuild();
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: SpacingScale.scaleOne),
                      decoration: const BoxDecoration(
                        color: GlobalColors.grey_25,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: SpacingScale.scaleOneAndHalf),
                            child: MitraCheckboxWidget(
                              isChecked:
                                  widget.dimensionContents![index].tempSelected,
                              checkboxTypeEnum:
                                  MitraCheckboxTypeEnum.circularWithDot,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: SpacingScale.custom(14),
                              horizontal: SpacingScale.scaleOneAndHalf,
                            ),
                            width: Get.width,
                            child: Text(
                              widget.dimensionContents![index].descr!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppTheme.text_sm(
                                  AppThemeTextStyleType.medium),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                // }
                // return Container();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingScale.scaleTwo),
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
                widget.dimensionContents!
                        .every((element) => element.tempSelected == false)
                    ? null
                    : widget.controller
                        .buttonAddFilterValues(
                        widget.dimensionContents!,
                        widget.filterModel,
                      )
                        .then((_) {
                        Get.back();
                      });
                // widget.controller.verifyHaveValueSelected();
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
