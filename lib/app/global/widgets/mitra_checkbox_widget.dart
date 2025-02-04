import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

enum MitraCheckboxTypeEnum {
  circularWithDot,
  rectangleWithCheck,
}

class MitraCheckboxWidget extends StatefulWidget {
  final bool isChecked;
  final MitraCheckboxTypeEnum checkboxTypeEnum;

  const MitraCheckboxWidget({
    Key? key,
    this.isChecked = false,
    required this.checkboxTypeEnum,
  }) : super(key: key);

  @override
  State<MitraCheckboxWidget> createState() => _MitraCheckboxWidgetState();
}

class _MitraCheckboxWidgetState extends State<MitraCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.checkboxTypeEnum) {
      case MitraCheckboxTypeEnum.circularWithDot:
        return _buildCircularWithDot();
      case MitraCheckboxTypeEnum.rectangleWithCheck:
        return _buildRectangleWithCheck();
      default:
        return _buildCircularWithDot();
    }
  }

  Widget _buildCircularWithDot() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: widget.isChecked ? GlobalColors.violet_25 : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isChecked
              ? GlobalColors.violet_600
              : GlobalColors.grey_300,
        ),
      ),
      child: widget.isChecked
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: GlobalColors.violet_600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildRectangleWithCheck() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: widget.isChecked ? GlobalColors.violet_25 : Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: widget.isChecked
              ? GlobalColors.violet_600
              : GlobalColors.grey_300,
        ),
      ),
      child: widget.isChecked
          ? const Center(
              child: Icon(
                Icons.check_rounded,
                color: GlobalColors.violet_600,
                size: 20,
              ),
            )
          : null,
    );
  }
}
