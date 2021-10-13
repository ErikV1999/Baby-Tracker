import 'package:baby_tracker/screens/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text('Baby Tracker'),
        backgroundColor: Colors.yellow[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();

            },
            label: Text('logout'),
          )
        ],
      )
    );
  }
}
