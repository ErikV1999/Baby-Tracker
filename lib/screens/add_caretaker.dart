import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/invites.dart';

class AddCaretaker extends StatefulWidget {

  final String baby;
  final String userEntry;
  final dynamic babyDoc;
  const AddCaretaker({Key? key, required this.baby, required this.userEntry, required this.babyDoc}) : super(key: key);

  @override
  State<AddCaretaker> createState() => _AddCaretakerState();
}

class _AddCaretakerState extends State<AddCaretaker> {

  String userID = "";
  dynamic msgController = TextEditingController();

  static Future<bool> validateUser(String userID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.collection("DisplayNames").doc(userID).get()
      .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return exists;
    }
  }
  void addPressed() async{

    if(widget.babyDoc["parent"]!=widget.userEntry){

      print("User is not parent");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "You are not the parent of this child",
                style: TextStyle(fontSize: 20)
            ),

          )
      );
      return;
    }
    bool valid = await validateUser(userID);
    print(userID);
    if(valid) {
      CollectionReference invites = FirebaseFirestore.instance.collection("Invites");

      await invites.add({
        "babyPath" : widget.baby,
        "receiver" : userID,
        "babyName" : widget.babyDoc["Name"]
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Caretaker Invited",
                style: TextStyle(fontSize: 20)
            ),

          )
      );
      setState(()=>userID = "");
      msgController.clear();

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Not a valid User",
              style: TextStyle(fontSize: 20)
          ),

        )
      );
      print("invalid");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: msgController,
                decoration: InputDecoration(
                  labelText: "users ID: ",

                ),
                onChanged: (val) {
                  setState(() => userID = val);
                }
              ),
              Container(
                  child: ElevatedButton(
                  child: Text("Add"),
                  onPressed: () async {
                    addPressed();
                  }

                )
              ),
              Container(
                  child: ElevatedButton(
                    child: Text("Invites"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Invites(user:widget.userEntry)),
                      );
                    }

                  )
              )


            ]
          )
        )
      )
    );
  }
}
