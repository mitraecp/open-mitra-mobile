import 'package:get_storage/get_storage.dart';

class StoreTypes {
  StoreTypes._();
  static const currentBaseUrlLink = 'current_base_url_link';
  static const currentBaseNameUrlLink = 'current_base_name_url_link';
  static const userToken = 'user_token';
  static const lastAccessView = 'last_accessView';
  static const mergeToken = 'merge_token';
  static const mergeUrl = 'merge_url';
  static const workspaceStoraged = 'workspace_storaged';
  static const projectStoraged = 'project_storaged';

  static disposeAllStore() {
    GetStorage().remove(StoreTypes.currentBaseUrlLink);
    GetStorage().remove(StoreTypes.currentBaseNameUrlLink);
    GetStorage().remove(StoreTypes.userToken);
    GetStorage().remove(StoreTypes.lastAccessView);
    GetStorage().remove(StoreTypes.mergeToken);
    GetStorage().remove(StoreTypes.mergeUrl);
    GetStorage().remove(StoreTypes.workspaceStoraged);
    GetStorage().remove(StoreTypes.projectStoraged);
  }
}
