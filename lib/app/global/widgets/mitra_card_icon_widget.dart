import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_mitra_mobile/app/helpers/mdi_map_icons.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';

class MitraCardIconWidget extends StatelessWidget {
  final String cardIcon;
  final String hexColor;
  final String cardInitials;
  final double iconSize;
  final double iconInitialsSize;
  final int wordsLength;

  const MitraCardIconWidget({
    Key? key,
    required this.cardIcon,
    required this.hexColor,
    required this.cardInitials,
    this.iconInitialsSize = 28,
    this.iconSize = 18,
    this.wordsLength = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cardIcon != 'initials') {
      return _getProjectIcon();
    } else {
      return _getInitialsToMakeIconWidget();
    }
  }

  Widget _getProjectIcon() {
    return Icon(
      getMdiIconToFlutterIcon(cardIcon),
      color: HexColor(hexColor),
      size: iconSize,
    );
  }

  Widget _getInitialsToMakeIconWidget() {
    // Divida a string em palavras usando espaço como delimitador
    List<String> words = cardInitials.split(' ');

    // Pegue a inicial de cada palavra e junte-as até um máximo de 3 iniciais
    String initials = '';
    for (var i = 0; i < words.length && i < wordsLength; i++) {
      initials += words[i][0];
    }

    // Crie e retorne o widget Text
    return SizedBox(
      width: iconInitialsSize,
      height: iconInitialsSize,
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTheme.text_xs(AppThemeTextStyleType.bold)
              .copyWith(fontWeight: FontWeight.w900, fontSize: 12)
              .copyWith(color: HexColor(hexColor)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
