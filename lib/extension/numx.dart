import 'package:flutter/cupertino.dart';

extension NumX on num {

  double widthPercent(BuildContext context) {
    return MediaQuery.of(context).size.width  * this;
  }

}