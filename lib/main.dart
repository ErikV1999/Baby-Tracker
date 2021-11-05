import 'package:baby_tracker/models/theme_provider.dart';
import 'package:baby_tracker/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:baby_tracker/screens/services/auth.dart';
import 'package:baby_tracker/models/myuser.dart';

import 'models/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<MyUser?>.value(
      initialData: null,
      catchError: (User, CustomUser) => null,
      value:  AuthService().user,
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Flutter Firebase',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: Wrapper(),
          );
        },
      )
//=======
    //return MaterialApp(

      //home: TittleScreen(),

    );
  }
}

