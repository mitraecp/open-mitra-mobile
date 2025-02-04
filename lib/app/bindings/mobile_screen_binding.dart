import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/detail_builder_controller.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/controllers/mobile_screen_controller.dart';
import 'package:open_mitra_mobile/app/controllers/profile_controller.dart';
import 'package:open_mitra_mobile/app/data/repository/detail_repository/detail_builder_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/detail_repository/interface/detail_builder_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/module_repository.dart/module_repository.dart';

class MobileScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<MobileScreenController>(
      () => MobileScreenController(),
      fenix: true,
    );
    Get.lazyPut<FilterBarController>(
      () => FilterBarController(),
      fenix: true,
    );
    Get.lazyPut<FilterBarController>(
      () => FilterBarController(),
      fenix: true,
    );

    Get.lazyPut<DetailBuilderController>(
      () => DetailBuilderController(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );

    // Repositorys
    Get.lazyPut<ModuleRepository>(
      () => ModuleRepository(),
    );

    Get.lazyPut<IDetailBuilderRepository>(
      () => DetailBuilderRepository(),
    );
  }
}
