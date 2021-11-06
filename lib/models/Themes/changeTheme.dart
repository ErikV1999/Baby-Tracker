import 'package:provider/provider.dart';
import 'package:baby_tracker/models/Themes/theme_provider.dart';
import 'package:flutter/material.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
      activeColor: MyThemes.blizzardBlue,
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggle(value);
      },
    );
  }
}
