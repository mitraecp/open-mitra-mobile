// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class GlobalColors {
  // Azul
  static const Color primary_25 = Color(0xFFF5FAFF);
  static const Color primary_50 = Color(0xFFEFF8FF);
  // static const Color primary_100 = Color(0xFFEFF1F7);
  // static const Color primary_200 = Color(0xFFE7E8F0);
  // static const Color primary_300 = Color(0xFFC7CBDD);
  // static const Color primary_400 = Color(0xFF8D95B3);
  // static const Color primary_500 = Color(0xFF424967);
  static const Color primary_600 = Color(0xFF1570EF);
  // static const Color primary_700 = Color(0xFF313854);
  // static const Color primary_800 = Color(0xFF1B2139);
  // static const Color primary_900 = Color(0xFF0E1428);

  // Grey
  static const Color grey_25 = Color(0xFFF8F9FD);
  static const Color grey_50 = Color(0xFFF6F7FB);
  static const Color grey_100 = Color(0xFFEFF1F7);
  static const Color grey_200 = Color(0xFFE7E8F0);
  static const Color grey_300 = Color(0xFFC7CBDD);
  static const Color grey_400 = Color(0xFF8D95B3);
  static const Color grey_500 = Color(0xFF424967);
  static const Color grey_600 = Color(0xFF424967);
  static const Color grey_700 = Color(0xFF313854);
  static const Color grey_800 = Color(0xFF1B2139);
  static const Color grey_900 = Color(0xFF0E1428);

  // Error
  static const Color error_25 = Color(0xFFFFFBFA);
  static const Color error_50 = Color(0xFFFEF3F2);
  static const Color error_100 = Color(0xFFFEE4E2);
  static const Color error_200 = Color(0xFFFECDCA);
  static const Color error_300 = Color(0xFFFDA29B);
  static const Color error_400 = Color(0xFFF97066);
  static const Color error_500 = Color(0xFFF04438);
  static const Color error_600 = Color(0xFFD92D20);
  static const Color error_700 = Color(0xFFB42318);
  static const Color error_800 = Color(0xFF912018);
  static const Color error_900 = Color(0xFF7A271A);

  // Success
  static const Color success_25 = Color(0xFFF6FEF9);
  static const Color success_50 = Color(0xFFECFDF3);
  static const Color success_100 = Color(0xFFD1FADF);
  static const Color success_200 = Color(0xFFA6F4C5);
  static const Color success_300 = Color(0xFF6CE9A6);
  static const Color success_400 = Color(0xFF32D583);
  static const Color success_500 = Color(0xFF12B76A);
  static const Color success_600 = Color(0xFF039855);
  static const Color success_700 = Color(0xFF027A48);
  static const Color success_800 = Color(0xFF05603A);
  static const Color success_900 = Color(0xFF054F31);

  // Violet
  static const Color violet_25 = Color(0xFFFBFAFF);
  static const Color violet_50 = Color(0xFFF5F3FF);
  static const Color violet_100 = Color(0xFFECE9FE);
  static const Color violet_200 = Color(0xFFDDD6FE);
  static const Color violet_300 = Color(0xFFC3B5FD);
  static const Color violet_400 = Color(0xFFA48AFB);
  static const Color violet_500 = Color(0xFF875BF7);
  static const Color violet_600 = Color(0xFF7839EE);
  static const Color violet_700 = Color(0xFF6927DA);
  static const Color violet_800 = Color(0xFF5720B7);
  static const Color violet_900 = Color(0xFF491C96);

  // Projetos ligth
  static const Color lightPurple = Color(0xffD9D6FF);
  static const Color lightViolet = Color(0xffFFD9FF);
  static const Color lightBlue = Color(0xFFD3F7FF);
  static const Color lightSky = Color(0xFFC3E1E4);
  static const Color lightGreen = Color(0xffCBECBB);
  static const Color lightYellow = Color(0xffFFF69E);
  static const Color lightOrange = Color(0xffFFEAC2);
  static const Color lightRed = Color(0xffFFD39C);
  static const Color lightPink = Color(0xffFFC9F8);

  // Projetos normal
  static const Color normalPurple = Color(0xff7839EE);
  static const Color normalViolet = Color(0xffB954BB);
  static const Color normalBlue = Color(0xFF1570EF);
  static const Color normalSky = Color(0xFF09A9BD);
  static const Color normalGreen = Color(0xff12B76A);
  static const Color normalYellow = Color(0xffFFB72D);
  static const Color normalOrange = Color(0xffF2911E);
  static const Color normalRed = Color(0xffDD5226);
  static const Color normalPink = Color(0xffDE3C76);

  //
  /// box-shadow: 0px 1px 2px 0px rgba(16, 24, 40, 0.05);
  static const BoxShadow shadow_xs = BoxShadow(
    color: Color.fromRGBO(16, 24, 40, 0.05),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  // box-shadow: 0px 1px 10px 0px #875BF740;
  static const BoxShadow shadow_violet = BoxShadow(
    color: Color.fromRGBO(135, 91, 247, 0.25),
    offset: Offset(0, 1),
    blurRadius: 10,
    spreadRadius: 0,
  );

  Color getSelectedAppPrimaryColor(String primaryColor) {
    try {
      // Verifica se a cor é uma string válida de formato hexadecimal
      return _parseColor(primaryColor);
    } catch (e) {
      // Se houver um erro ao tentar parsear, retorna a cor padrão
      return GlobalColors.violet_600;
    }
  }

  Color _parseColor(String colorString) {
    // Aqui você pode lidar com algumas cores por nome, como 'red', 'blue', etc.
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      // Adicione mais cores nomeadas se precisar.
      default:
        // Tenta tratar como uma cor hexadecimal, ex: '#ff0000' ou '0xff0000'
        if (colorString.startsWith('#')) {
          // Converte de hexadecimal
          return Color(
              int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
        } else if (colorString.startsWith('0x')) {
          // Converte de hexadecimal no formato 0xFFxxxxxx
          return Color(int.parse(colorString));
        } else {
          // Se não corresponder a nenhum formato, lança um erro
          throw const FormatException("Cor inválida");
        }
    }
  }
}
