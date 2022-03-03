import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static int _getRightColorFromHex(String hexColor, int color) {
    try {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return color;
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  HexColor.right(
    final String hexColor,
    final int defaultColor,
  ) : super(_getRightColorFromHex(hexColor, defaultColor));
}
