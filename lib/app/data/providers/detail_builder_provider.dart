import 'package:get/get_connect/connect.dart';
import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_button_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';

class DetailBuilderProvider extends GetConnect {
  Future<List<DetailBuilderButtonModel>> getDetailButtonList(
      RefreshTokenModel mergeRefreshToken, int detailBuilderId) async {
    final backUrl = mergeRefreshToken.merge?.backURL ?? '';

    final headers = {
      "Accept": "application/json",
      "Cache-Control": "no-cache",
      "Authorization": 'Bearer ${mergeRefreshToken.merge?.userToken}'
    };

    var response = await get(
      "$backUrl/detailBuilderButton/detailBuilder/$detailBuilderId",
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> responseData = response.body;
      List<DetailBuilderButtonModel> listOfDetailBuilderButtons = responseData
          .map((map) =>
              DetailBuilderButtonModel.fromMap(map as Map<String, dynamic>))
          .toList();

      return listOfDetailBuilderButtons;
    } else {
      throw Exception(response.bodyString);
    }
  }
}
