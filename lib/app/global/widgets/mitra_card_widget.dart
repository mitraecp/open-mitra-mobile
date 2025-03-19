// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_checkbox_widget.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MitraCardWidget extends StatelessWidget {
  final Color cardBackground;
  final double cardPadding;
  final Color cardBorderColor;
  final Widget? cardIcon;
  final Widget? prefixWidget;
  final Color? cardIconColor;
  final double cardIconBackgroundSize;
  final BoxShape cardIconShape;
  final String cardTitle;
  final TextStyle cardTitleStyle;
  final String cardSubTitle;
  final TextStyle? cardSubTitleStyle;
  final bool isHorizontalCard;
  final bool isWithCheckbox;
  final bool isCheckboxSeleceted;
  final BoxShadow cardBoxShadow;
  final Widget? sufixWidget;
  final double cardHeight;
  final Function()? onChanged;
  final BoxBorder? cardBorderConfig;
  final BorderRadiusGeometry? cardBorderRadius;
  final EdgeInsetsGeometry? cardPaddingWidget;
  final bool cardDisabled;

  const MitraCardWidget({
    Key? key,
    this.cardBackground = Colors.white,
    this.cardPadding = SpacingScale.scaleTwo,
    this.cardBorderColor = GlobalColors.grey_200,
    this.cardIcon,
    this.cardIconColor,
    this.prefixWidget,
    this.cardIconShape = BoxShape.rectangle,
    this.cardIconBackgroundSize = 10,
    required this.cardTitle,
    required this.cardTitleStyle,
    this.cardSubTitle = '',
    this.cardSubTitleStyle,
    this.isHorizontalCard = false,
    this.isWithCheckbox = false,
    this.isCheckboxSeleceted = false,
    this.onChanged,
    this.sufixWidget,
    this.cardHeight = 70,
    this.cardBoxShadow = GlobalColors.shadow_xs,
    this.cardBorderConfig,
    this.cardBorderRadius,
    this.cardPaddingWidget,
    this.cardDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: cardPaddingWidget ?? EdgeInsets.all(cardPadding),
      height: cardHeight,
      decoration: BoxDecoration(
        color: cardBackground,
        border: cardDisabled
            ? Border.all(color: GlobalColors.grey_50)
            : Border.all(color: cardBorderColor),
        borderRadius:
            cardBorderRadius ?? const BorderRadius.all(Radius.circular(8)),
        boxShadow: [cardBoxShadow],
      ),
      child: _verticalCard(),
    );
  }

  Widget _verticalCard() {
    return IntrinsicWidth(
      child: InkWell(
        onTap: cardDisabled ? () {} : onChanged,
        child: Row(
          children: [
            cardIcon == null && cardIconColor == null
                ? prefixWidget != null
                    ? prefixWidget!
                    : const SizedBox()
                : Container(
                    padding: EdgeInsets.all(
                        SpacingScale.custom(cardIconBackgroundSize)),
                    decoration: BoxDecoration(
                      color: cardIconColor!.withOpacity(0.3),
                      borderRadius: cardIconShape == BoxShape.circle
                          ? null
                          : const BorderRadius.all(
                              Radius.circular(6),
                            ),
                      shape: cardIconShape,
                    ),
                    child: cardIcon,
                  ),
            const SizedBox(width: SpacingScale.scaleOneAndHalf),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardTitle,
                    overflow: TextOverflow.ellipsis,
                    style: cardTitleStyle,
                  ),
                  cardSubTitle != ''
                      ? Text(
                          cardSubTitle,
                          overflow: TextOverflow.ellipsis,
                          style: cardSubTitleStyle,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(width: SpacingScale.scaleOneAndHalf),
            sufixWidget != null ? sufixWidget! : const SizedBox(),
            isWithCheckbox
                ? MitraCheckboxWidget(
                    isChecked: isCheckboxSeleceted,
                    checkboxTypeEnum: MitraCheckboxTypeEnum.circularWithDot,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
