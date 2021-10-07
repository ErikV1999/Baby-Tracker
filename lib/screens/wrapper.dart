import 'package:baby_tracker/screens/authenticate/authenticate.dart';
import 'package:baby_tracker/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baby_tracker/models/myuser.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);
    print(user);

    //return either Home or Authenticate widget
    if (user == null)
      {
        return Authenticate();
      }
      else
        {
          return Home();
        }
  }
}
