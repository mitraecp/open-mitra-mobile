import 'package:get/get_connect/connect.dart';
import 'package:open_mitra_mobile/app/data/model/user_models/logged_user_model.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';

const baseUrl = 'http://gerador-nomes.herokuapp.com/nomes/10';

class MenuPageProvider extends GetConnect {
  Future<bool> sendReportError(
      {required LoggedUser loggedUser, required String message}) async {
    final response = await post(
      "https://node-api.mitraecp.com/sendMail",
      {
        "email": loggedUser.email,
        "message": message,
        "mode": "mobile",
        "name": loggedUser.name,
        "subjects": globalEmailSuporteApp,
      },
    );
    if (response.statusCode != 200) {
      // throw Exception("Error code: ${response.statusCode}");
      return false;
    } else {
      return true;
    }
  }
}
