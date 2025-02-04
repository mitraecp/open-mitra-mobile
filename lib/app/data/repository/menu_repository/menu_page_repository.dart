
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/data/providers/menu_page_provider.dart';
import 'package:open_mitra_mobile/app/data/repository/menu_repository/interface/menu_page_repository_interface';

class MenuPageRepository extends IMenuPageRepository {
  final MenuPageProvider apiClient = MenuPageProvider();

  @override
  Future<bool> sendReportError(
      {required LoggedUser loggedUser, required String message}) {
    return apiClient.sendReportError(loggedUser: loggedUser, message: message);
  }
}
