import 'package:flutter/material.dart';

class CustomColors {
  Map<int, Color> color1 = {
    50: Color.fromRGBO(27 , 103 , 134 , .1),
    100: Color.fromRGBO(27 , 103 , 134 , .2),
    200: Color.fromRGBO(27 , 103 , 134 , .3),
    300: Color.fromRGBO(27 , 103 , 134 , .4),
    400: Color.fromRGBO(27 , 103 , 134 , .5),
    500: Color.fromRGBO(27 , 103 , 134 , .6),
    600: Color.fromRGBO(27 , 103 , 134 , .7),
    700: Color.fromRGBO(27 , 103 , 134 , .8),
    800: Color.fromRGBO(27 , 103 , 134 , .9),
    900: Color.fromRGBO(27 , 103 , 134 , 1),
  };

  Map<int, Color> color2 = {
    50: Color.fromRGBO(255 , 152 , 0 , .1),
    100: Color.fromRGBO(255 , 152 , 0 , .2),
    200: Color.fromRGBO(255 , 152 , 0 , .3),
    300: Color.fromRGBO(255 , 152 , 0 , .4),
    400: Color.fromRGBO(255 , 152 , 0 , .5),
    500: Color.fromRGBO(255 , 152 , 0 , .6),
    600: Color.fromRGBO(255 , 152 , 0 , .7),
    700: Color.fromRGBO(255 , 152 , 0 , .8),
    800: Color.fromRGBO(255 , 152 , 0 , .9),
    900: Color.fromRGBO(255 , 152 , 0 , 1),
  };

  MaterialColor getColor({int i = 0}) {
    if(i % 2 == 0) return MaterialColor(0xff1B6786 , color1);
    else return MaterialColor(0xffFF9800 , color2);
  }

}
