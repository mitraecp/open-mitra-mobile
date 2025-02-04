import 'dart:convert';

import 'package:get/get.dart';

class GithubService extends GetConnect {
  static const String mobileBaseReference =
      'https://raw.githubusercontent.com/mitraecp/frontend-resoucers/master/mobile_mitra_apps_api_base_reference.json';

  Future<Map<String, dynamic>> getIsToUseQAUrl() async {
    try {
      final response = await get(mobileBaseReference);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }
}
