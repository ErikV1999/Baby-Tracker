import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggle(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return themeMode;
  }
}

class MyThemes {
  static final kobiPink = Color(0xFFDD99BB);
  static final blueSapphire = Color(0xFF006992);
  static final blizzardBlue = Color(0xFF79E6F1);
  static final orangeYellow = Color(0xFFEABE25);
  static final orangeYellow1 = Color(0xFFEFC648);

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: blueSapphire,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: blizzardBlue, foregroundColor: Colors.black,),
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(color: orangeYellow),
    cardColor: orangeYellow,
    accentColor: Colors.grey[400],
    textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white)
    ),

   // cardTheme: CardTheme( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
  );

  static final lightTheme =  ThemeData(
    brightness: Brightness.light,
    primaryColor: blizzardBlue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: blueSapphire, foregroundColor: Colors.white),
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(color: Colors.amber),
    cardColor: Colors.amber,
    accentColor: Colors.white,
    textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black)
    ),
    //cardTheme: CardTheme( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
  );

}