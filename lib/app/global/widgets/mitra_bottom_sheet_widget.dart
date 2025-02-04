import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_card_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

void showMitraBottomSheetWidget({
  required Widget headerTitle,
  required List<MitraBottomSheetItemModel> listOfMitraBottomSheetItem,
  bottomSheetIsToShowCheckBox = true,
  required Function(int) onChanged,
  Color cardIconBackground = GlobalColors.violet_600,
  Color cardBackground = GlobalColors.grey_25,
  Color cardBorderColor = GlobalColors.grey_25,
  cardPadding = SpacingScale.scaleOneAndHalf,
  cardIconBackgroundSize = SpacingScale.scaleHalf,
  double? bottonSheetHeight,
  double? bottomSheetListGeneratorHeight,
  TextEditingController? searchTextController,
  ScrollPhysics? listItemPhysics = const AlwaysScrollableScrollPhysics(),
  double cardHeight = 70,
}) {
  Get.bottomSheet(
    _buildBottomSheetBody(
      headerTitle: headerTitle,
      listOfMitraBottomSheetItem: listOfMitraBottomSheetItem,
      onChanged: onChanged,
      cardIconBackground: cardIconBackground,
      cardBackground: cardBackground,
      cardBorderColor: cardBorderColor,
      bottomSheetIsToShowCheckBox: bottomSheetIsToShowCheckBox,
      cardPadding: cardPadding,
      cardIconBackgroundSize: cardIconBackgroundSize,
      bottonSheetHeight: bottonSheetHeight,
      bottomSheetListGeneratorHeight: bottomSheetListGeneratorHeight,
      searchTextController: searchTextController,
      listItemPhysics: listItemPhysics,
      cardHeight: cardHeight,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: false,
    barrierColor: Colors.grey.withOpacity(0.6),
    enterBottomSheetDuration: const Duration(milliseconds: 200),
  );
}

Widget _buildBottomSheetBody({
  required Widget headerTitle,
  required List<MitraBottomSheetItemModel> listOfMitraBottomSheetItem,
  required Function(int) onChanged,
  RxList<MitraBottomSheetItemModel>? rxListOfMitraBottomSheetItem,
  Color cardIconBackground = GlobalColors.violet_600,
  cardBackground = GlobalColors.grey_25,
  cardBorderColor = GlobalColors.grey_25,
  bottomSheetIsToShowCheckBox = true,
  cardPadding = SpacingScale.scaleOneAndHalf,
  cardIconBackgroundSize = SpacingScale.scaleHalf,
  double? bottonSheetHeight,
  double? bottomSheetListGeneratorHeight,
  TextEditingController? searchTextController,
  ScrollPhysics? listItemPhysics = const AlwaysScrollableScrollPhysics(),
  double cardHeight = 70,
}) {
  RxList<MitraBottomSheetItemModel> filteredListOfMitraBottomSheetItem =
      <MitraBottomSheetItemModel>[].obs;

  filteredListOfMitraBottomSheetItem.value =
      List.from(listOfMitraBottomSheetItem);

  return Container(
    margin: const EdgeInsets.symmetric(
        vertical: SpacingScale.scaleFour,
        horizontal: SpacingScale.scaleTwoAndHalf),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(SpacingScale.scaleTwo),
      ),
    ),
    child: Container(
      padding: const EdgeInsets.only(
        top: SpacingScale.scaleTwo,
        bottom: SpacingScale.scaleThree,
        left: SpacingScale.scaleThree,
        right: SpacingScale.scaleThree,
      ),
      child: SizedBox(
        height: bottonSheetHeight ?? Get.height / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOfWorkspaceBottomSheet(headerTitle),
            searchTextController != null
                ? const SizedBox()
                : const SizedBox(height: SpacingScale.scaleTwo),
            searchTextController != null
                ? _searchInput(
                    searchTextController,
                    filteredListOfMitraBottomSheetItem,
                    listOfMitraBottomSheetItem)
                : const SizedBox(),
            searchTextController != null
                ? const SizedBox(height: SpacingScale.scaleTwo)
                : const SizedBox(),
            _buildMenuListOfWorkspaceBottomSheet(
              listItemPhysics: listItemPhysics,
              listOfMitraBottomSheetItem: filteredListOfMitraBottomSheetItem,
              onChanged: onChanged,
              cardIconBackground: cardIconBackground,
              cardBackground: cardBackground,
              cardBorderColor: cardBorderColor,
              bottomSheetIsToShowCheckBox: bottomSheetIsToShowCheckBox,
              cardPadding: cardPadding,
              cardIconBackgroundSize: cardIconBackgroundSize,
              bottomSheetListGeneratorHeight: bottomSheetListGeneratorHeight,
              searchTextController: searchTextController,
              cardHeight: cardHeight,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHeaderOfWorkspaceBottomSheet(Widget headerTitle) {
  return Row(
    children: [
      headerTitle,
      const Spacer(),
      InkWell(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.close_rounded,
          color: GlobalColors.grey_500,
          size: 20,
        ),
      )
    ],
  );
}

Widget _searchInput(
  TextEditingController? searchTextController,
  RxList<MitraBottomSheetItemModel> filteredListOfMitraBottomSheetItem,
  List<MitraBottomSheetItemModel> listOfMitraBottomSheetItem,
) {
  searchTextController!.addListener(() {
    filterList(searchTextController.text, filteredListOfMitraBottomSheetItem,
        listOfMitraBottomSheetItem);
  });

  return MitraInputTextField(
    obscureText: false,
    controller: searchTextController,
    inputTitle: '',
    inputShadowColorDefault: GlobalColors.grey_25,
    inputTitleStyle: AppTheme.text_md(AppThemeTextStyleType.regular)
        .copyWith(color: GlobalColors.grey_900),
    inputHintText: 'search_2'.tr,
    inputHintStyle: AppTheme.text_md(AppThemeTextStyleType.regular)
        .copyWith(color: GlobalColors.grey_500),
    showPassword: false,
    inputTextType: TextInputType.emailAddress,
    inputError: false,
    prefixIconWidget: const Icon(
      Icons.search,
      size: 20,
      color: GlobalColors.grey_500,
    ),
    suffixIconWidget: searchTextController.text != ''
        ? const SizedBox()
        : InkWell(
            onTap: () {
              searchTextController.text = '';
            },
            child: const Icon(
              Icons.close,
              size: 20,
              color: GlobalColors.grey_500,
            ),
          ),
  );
}

void filterList(
  String searchTerm,
  RxList<MitraBottomSheetItemModel> filteredListOfMitraBottomSheetItem,
  List<MitraBottomSheetItemModel> listOfMitraBottomSheetItem,
) {
  if (searchTerm.isEmpty) {
    filteredListOfMitraBottomSheetItem.value =
        List.from(listOfMitraBottomSheetItem);
  } else {
    filteredListOfMitraBottomSheetItem.value = listOfMitraBottomSheetItem
        .where((item) =>
            item.itemName.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }
}

Widget _buildMenuListOfWorkspaceBottomSheet({
  required List<MitraBottomSheetItemModel> listOfMitraBottomSheetItem,
  Color cardIconBackground = GlobalColors.violet_600,
  cardBackground = GlobalColors.grey_25,
  cardBorderColor = GlobalColors.grey_25,
  required Function(int) onChanged,
  bottomSheetIsToShowCheckBox = true,
  cardPadding = SpacingScale.scaleOneAndHalf,
  cardIconBackgroundSize = SpacingScale.scaleHalf,
  double? bottomSheetListGeneratorHeight,
  TextEditingController? searchTextController,
  ScrollPhysics? listItemPhysics = const AlwaysScrollableScrollPhysics(),
  double cardHeight = 70,
}) {
  return SizedBox(
    height: bottomSheetListGeneratorHeight ?? Get.height / 5,
    child: searchTextController != null
        ? Obx(
            () => ListView.builder(
              physics: listItemPhysics,
              itemCount: listOfMitraBottomSheetItem.length,
              itemBuilder: ((context, index) {
                final MitraBottomSheetItemModel currentItem =
                    listOfMitraBottomSheetItem[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: SpacingScale.scaleOne),
                  child: InkWell(
                    onTap: () {
                      onChanged(currentItem.itemId!);
                    },
                    child: MitraCardWidget(
                      cardPadding: cardPadding,
                      cardBackground: cardBackground,
                      cardBorderColor: cardBorderColor,
                      cardIcon: currentItem.itemIcon,
                      cardHeight: cardHeight,
                      cardIconColor:
                          currentItem.itemIconBgColor ?? cardIconBackground,
                      cardIconShape: BoxShape.circle,
                      cardIconBackgroundSize: cardIconBackgroundSize,
                      cardTitle: currentItem.itemName,
                      cardTitleStyle:
                          AppTheme.text_sm(AppThemeTextStyleType.medium)
                              .copyWith(overflow: TextOverflow.ellipsis),
                      isWithCheckbox: bottomSheetIsToShowCheckBox,
                      isCheckboxSeleceted: currentItem.isSelected,
                    ),
                  ),
                );
              }),
            ),
          )
        : ListView.builder(
            physics: listItemPhysics,
            itemCount: listOfMitraBottomSheetItem.length,
            itemBuilder: ((context, index) {
              final MitraBottomSheetItemModel currentItem =
                  listOfMitraBottomSheetItem[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: SpacingScale.scaleOne),
                child: InkWell(
                  onTap: () {
                    onChanged(index);
                  },
                  child: MitraCardWidget(
                    cardPadding: cardPadding,
                    cardBackground: cardBackground,
                    cardBorderColor: cardBorderColor,
                    cardHeight: cardHeight,
                    cardIcon: currentItem.itemIcon,
                    cardIconColor:
                        currentItem.itemIconBgColor ?? cardIconBackground,
                    cardIconShape: BoxShape.circle,
                    cardIconBackgroundSize: cardIconBackgroundSize,
                    cardTitle: currentItem.itemName,
                    cardTitleStyle:
                        AppTheme.text_sm(AppThemeTextStyleType.medium)
                            .copyWith(overflow: TextOverflow.ellipsis),
                    isWithCheckbox: bottomSheetIsToShowCheckBox,
                    isCheckboxSeleceted: currentItem.isSelected,
                  ),
                ),
              );
            }),
          ),
  );
}
