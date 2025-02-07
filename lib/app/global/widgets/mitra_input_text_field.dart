import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MitraInputTextField extends StatefulWidget {
  final String inputTitle;
  final TextStyle inputTitleStyle;
  final String inputHintText;
  final TextStyle inputHintStyle;
  final TextEditingController controller;
  final bool obscureText;
  final bool showPassword;
  final Widget? prefixWidget;
  final Widget? prefixIconWidget;
  final Widget? suffixIconWidget;
  final bool inputError;
  final TextInputType inputTextType;
  final void Function(String)? onInputChanged;
  final Color inputShadowColorDefault;
  final bool disabled;
  final Color backgroundColor;
  final bool isToShowTitle;
  final double inputBorderRadius;
  final double inputHeight;
  final Color defaultBorderColor;
  final Color inputFocusShadowColor;

  const MitraInputTextField({
    Key? key,
    required this.inputTitle,
    required this.inputTitleStyle,
    required this.controller,
    required this.obscureText,
    required this.showPassword,
    this.prefixWidget,
    this.prefixIconWidget,
    this.suffixIconWidget,
    required this.inputError,
    required this.inputHintText,
    required this.inputHintStyle,
    this.onInputChanged,
    required this.inputTextType,
    this.inputShadowColorDefault = Colors.white,
    this.disabled = false,
    this.backgroundColor = Colors.white,
    this.isToShowTitle = true,
    this.inputBorderRadius = 8,
    this.inputHeight = 44,
    this.defaultBorderColor = GlobalColors.grey_300,
    this.inputFocusShadowColor = GlobalColors.violet_100,
  }) : super(key: key);

  @override
  State<MitraInputTextField> createState() => _MitraInputTextFieldState();
}

class _MitraInputTextFieldState extends State<MitraInputTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isToShowTitle
            ? Text(
                widget.inputTitle,
                style: widget.inputTitleStyle,
              )
            : const SizedBox(),
        widget.isToShowTitle
            ? SizedBox(
                height: SpacingScale.custom(6),
              )
            : const SizedBox(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.inputHeight,
          decoration: BoxDecoration(
            color: widget.disabled
                ? GlobalColors.grey_50
                : widget.backgroundColor, // Cor do fundo do TextField
            borderRadius: BorderRadius.circular(widget.inputBorderRadius),
            boxShadow: [
              BoxShadow(
                color: _shadowColorRule(),
                spreadRadius: 4,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                if (widget.disabled) {
                  isFocused = false;
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                } else {
                  isFocused = hasFocus;
                }
              });
            },
            child: TextField(
              readOnly: widget.disabled,
              textAlignVertical: TextAlignVertical
                  .center, // Por algum motivo o bottom centraliza quando tem hintText
              textAlign: TextAlign.start,
              obscureText: widget.obscureText && !widget.showPassword,
              controller: widget.controller,
              onChanged: widget.onInputChanged,
              keyboardType: widget.inputTextType,
              decoration: InputDecoration(
                  hintText: widget.inputHintText,
                  hintStyle: widget.inputHintStyle,
                  prefixIcon: widget.prefixIconWidget,
                  prefixIconColor: GlobalColors.grey_500,
                  prefix: widget.prefixWidget,
                  focusedBorder: widget.inputError
                      ? _errorOutlineInputBorder()
                      : OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.appPrimary_600,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.inputBorderRadius),
                          ),
                        ),
                  enabledBorder: widget.inputError
                      ? _errorOutlineInputBorder()
                      : OutlineInputBorder(
                          borderSide:
                              BorderSide(color: widget.defaultBorderColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.inputBorderRadius),
                          ),
                        ),
                  suffixIcon: widget.suffixIconWidget,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0)),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _errorOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: GlobalColors.error_300),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    );
  }

  Color _shadowColorRule() {
    return isFocused
        ? widget.inputError
            ? GlobalColors.error_100
            : widget.inputFocusShadowColor == GlobalColors.violet_100
                ? GlobalColors.appPrimary_100
                : widget.inputFocusShadowColor
        : widget.inputShadowColorDefault;
  }
}
