import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/controllers/menu_page_controller.dart';
import 'package:open_mitra_mobile/app/controllers/profile_controller.dart';
import 'package:open_mitra_mobile/app/controllers/project_controller.dart';
import 'package:open_mitra_mobile/app/data/repository/menu_repository/interface/menu_page_repository_interface';
import 'package:open_mitra_mobile/app/data/repository/menu_repository/menu_page_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/interface/project_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/project_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/interface/user_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/user_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<IProjectRepository>(() => ProjectRepository(), fenix: true);
    Get.lazyPut<IMenuPageRepository>(() => MenuPageRepository(), fenix: true);
    Get.lazyPut<IUserRepository>(() => UserRepository(), fenix: true);

    // Controllers
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<MenuPageController>(
        () => MenuPageController(menuRepository: Get.find()),
        fenix: true);

    Get.put<ProjectController>(
      ProjectController(projectRepository: Get.find<IProjectRepository>()),
      permanent: true,
    );

    Get.put<HomeController>(
      HomeController(),
      permanent: true,
    );
  }
}
