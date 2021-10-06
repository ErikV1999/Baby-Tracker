import 'package:flutter/material.dart';

class Feeding extends StatefulWidget {
  const Feeding({Key? key}) : super(key: key);

  @override
  _FeedingState createState() => _FeedingState();
}

class _FeedingState extends State<Feeding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white38,
        appBar: AppBar(
          title: Text('Homepage'),
          centerTitle: true,
          backgroundColor: Colors.amber,
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
                )
              ],
            )
        )
    );
  }
}