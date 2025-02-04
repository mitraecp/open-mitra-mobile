class SpacingScale {
  //
  /// 0
  static const double scaleZero = 0;
  //
  /// 4
  static const double scaleHalf = 4;
  //
  /// 8
  static const double scaleOne = 8;
  //
  /// 12
  static const double scaleOneAndHalf = 12;
  //
  /// 16
  static const double scaleTwo = 16;
  //
  /// 20
  static const double scaleTwoAndHalf = 20;
  //
  /// 24
  static const double scaleThree = 24;
  //
  /// 32
  static const double scaleFour = 32;
  //
  /// 40
  static const double scaleFive = 40;
  //
  /// 48
  static const double scaleSix = 48;
  //
  /// Use this method if you need a custom value
  static double custom(double value) => value;
  //
  /// Use this method to multiply values ​​by 8
  static double multiple(double value) => scaleOne * value;
}
