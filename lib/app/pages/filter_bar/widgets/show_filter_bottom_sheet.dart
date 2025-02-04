import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/mobile_screen_controller.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/filter_bar_view.dart';

void showFilterBottomSheet(MobileScreenController controller) {

  Get.bottomSheet(
    FilterBarView(),
    isScrollControlled: true,
    enableDrag: false,
    barrierColor:  Colors.grey.shade500,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
  );
}
