// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    return RichText(
      text: TextSpan(
        style: AppTheme.text_xs(AppThemeTextStyleType.regular)
            .copyWith(color: GlobalColors.grey_400),
        children: <TextSpan>[
          TextSpan(
            text: 'Mitra $currentYear | ',
          ),
          TextSpan(
            text: 'version'.tr,
          ),
          TextSpan(
            text: "v$globalAppVersion",
          ),
        ],
      ),
    );
  }
}
