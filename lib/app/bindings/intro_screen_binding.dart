import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/controllers/user_controller.dart';
import 'package:open_mitra_mobile/app/controllers/webview_store_controller.dart';
import 'package:open_mitra_mobile/app/controllers/workspace_controller.dart';
import 'package:open_mitra_mobile/app/data/repository/auth_repository/auth_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/auth_repository/interface/auth_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/interface/project_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/project_repository/project_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/interface/user_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/user_repository/user_repository.dart';
import 'package:open_mitra_mobile/app/data/repository/workspace_repository/interface/workspace_repository_interface.dart';
import 'package:open_mitra_mobile/app/data/repository/workspace_repository/workspace_repository.dart';

import '../controllers/intro_screen_controller.dart';

class IntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImp(), fenix: true);
    Get.lazyPut<IWorkspaceRepository>(() => WorkspaceRepository(), fenix: true);
    Get.lazyPut<IUserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<IProjectRepository>(() => ProjectRepository(), fenix: true);

    // Controllers
    Get.lazyPut<IntroScreenController>(() => IntroScreenController(),
        fenix: true);

    Get.put<WorkspaceController>(
      WorkspaceController(
        repository: Get.find<IWorkspaceRepository>(),
      ),
      permanent: true,
    );
    Get.put<UserController>(
        UserController(
          repository: Get.find<IUserRepository>(),
        ),
        permanent: true);

    Get.put<LoginController>(
      LoginController(repository: Get.find<IAuthRepository>()),
      permanent: true,
    );

    Get.put<WebViewStore>(
      WebViewStore(),
      permanent: true,
    );
  }
}
