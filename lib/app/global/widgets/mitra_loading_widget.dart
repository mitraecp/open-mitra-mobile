import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

class MitraLoadingWidget extends StatelessWidget {
  final double circleStrokeAlign;
  final double circleStrokeWidth;
  final Color circleColor;

  // ignore: use_super_parameters
  const MitraLoadingWidget({
    Key? key,
    this.circleStrokeAlign = 0,
    this.circleStrokeWidth = 4.0,
    this.circleColor = GlobalColors.violet_800,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: circleColor == GlobalColors.violet_800
          ? GlobalColors.appPrimary_800
          : circleColor,
      strokeAlign: circleStrokeAlign,
      strokeWidth: circleStrokeWidth,
    );
  }
}
