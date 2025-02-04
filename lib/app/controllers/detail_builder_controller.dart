import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_button_model.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/repository/detail_repository/interface/detail_builder_repository_interface.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/mitra_bottom_sheet_item_model.dart';
import 'package:open_mitra_mobile/app/global/widgets/widgets_models/timeline_item_option_model.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

class DetailBuilderController extends GetxController {
  final IDetailBuilderRepository repository;

  DetailBuilderController({required this.repository});

  Rx<DetailBuilderModel> selectedDetailBuilder =
      Rx(DetailBuilderModel(name: '', id: -1));

  Rx<List<DetailBuilderButtonModel>> selectedDetailButtons =
      Rx<List<DetailBuilderButtonModel>>([]);

  Rx<List<DetailBuilderButtonModel>> selectedDetailButtonsWithTopFlag =
      Rx<List<DetailBuilderButtonModel>>([]);

  Rx<TimelineItemOptionModel> selectedTimelineItemOption = Rx(
    TimelineItemOptionModel(
      selectedTimelineIndex: -1,
      selectedTimelineItem: [],
    ),
  );

  getDetailButtonList(RefreshTokenModel mergeRefreshToken) async {
    selectedDetailButtons.value = [];
    selectedDetailButtons.value = await repository.getDetailButtonList(
        mergeRefreshToken, selectedDetailBuilder.value.id);
    createButtonListWithOnlyTopFlag();
  }

  createButtonListWithOnlyTopFlag() {
    selectedDetailButtonsWithTopFlag.value = [];
    for (var i = 0; i < selectedDetailButtons.value.length; i++) {
      if (selectedDetailButtons.value[i].screenPosition == "TOP") {
        selectedDetailButtonsWithTopFlag.value
            .add(selectedDetailButtons.value[i]);
      }
    }
  }

  getListOfMitraBottomSheetItemOfTimelineMenu() {
    List<MitraBottomSheetItemModel> tempDetailButtonList = [];

    MitraBottomSheetItemModel tempItemEdit = MitraBottomSheetItemModel(
      isSelected: false,
      itemIcon: const Icon(
        Icons.edit_outlined,
        size: 20,
      ),
      itemName: 'edit'.tr,
      itemId: 0,
    );

    MitraBottomSheetItemModel tempItemDelete = MitraBottomSheetItemModel(
      isSelected: false,
      itemIcon: const Icon(
        Icons.delete_outline,
        size: 20,
        color: GlobalColors.error_600,
      ),
      itemName: 'delete'.tr,
      itemId: 1,
    );

    tempDetailButtonList.add(tempItemEdit);
    tempDetailButtonList.add(tempItemDelete);

    return tempDetailButtonList;
  }
}
