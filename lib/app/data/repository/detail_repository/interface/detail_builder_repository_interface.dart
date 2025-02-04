

import 'package:open_mitra_mobile/app/data/model/detail_builder_models/detail_builder_button_model.dart';
import 'package:open_mitra_mobile/app/data/model/projects_models/refresh_token_model.dart';

abstract class IDetailBuilderRepository {
  Future<List<DetailBuilderButtonModel>> getDetailButtonList(
      RefreshTokenModel mergeRefreshToken, int detailBuilderId);
}
