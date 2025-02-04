import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

class MitraDividerWidget extends StatelessWidget {
  // ignore: use_super_parameters
  const MitraDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: GlobalColors.grey_200,
      height: 4,
      thickness: 1,
    );
  }
}
