// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle style;
  final void Function()? onTapAction;

  const SearchWidget({
    Key? key,
    this.text = '',
    required this.onChanged,
    required this.hintText,
    this.hintStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: Color(0xff9D9DB6),
    ),
    this.style = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: Color(0xff6A6A82),
    ),
    this.onTapAction,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GlobalColors.grey_300),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SpacingScale.custom(14),
        vertical: SpacingScale.custom(10),
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: SpacingScale.custom(10)),
          icon:
              const Icon(Icons.search, color: GlobalColors.grey_500, size: 22),
          suffix: InkWell(
            child: const Icon(
              Icons.close,
              color: GlobalColors.grey_500,
              size: 16,
            ),
            onTap: () {
              setState(() {});
              controller.clear();
              widget.onChanged('');
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          hintText: widget.hintText,
          hintStyle: AppTheme.text_md(AppThemeTextStyleType.regular)
              .copyWith(color: GlobalColors.grey_500),
          border: InputBorder.none,
        ),
        style: AppTheme.text_md(AppThemeTextStyleType.regular),
        onChanged: widget.onChanged,
      ),
    );
  }
}
