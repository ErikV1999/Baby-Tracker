import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/feeding.dart';

class TittleScreen extends StatelessWidget {
  const TittleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Text('Homepage'),
        centerTitle: true,
          backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
            child: const Text('Feeding'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Feeding()),
              );
            }
            ),
            ElevatedButton(
                child: const Text('screen'),
                onPressed: () {}
            )
          ],
        )
      )
    );
  }
}


