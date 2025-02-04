

import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_button_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';
import 'package:open_mitra_mobile/app/data/providers/detail_builder_provider.dart';
import 'package:open_mitra_mobile/app/data/repository/detail_repository/interface/detail_builder_repository_interface.dart';

class DetailBuilderRepository extends IDetailBuilderRepository {
  final DetailBuilderProvider apiClient = DetailBuilderProvider();

  @override
  Future<List<DetailBuilderButtonModel>> getDetailButtonList(
      RefreshTokenModel mergeRefreshToken, int detailBuilderId) {
    return apiClient.getDetailButtonList(mergeRefreshToken, detailBuilderId);
  }
}
