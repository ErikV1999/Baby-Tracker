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

  static Future<bool> validateUser(String userID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.collection("Users").doc(userID).get()
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
    //String parent = widget.babyDoc["parent"];
    //dynamic babyDoc = await FirebaseFirestore.instance.doc(widget.baby).snapshots();
    //String babyParent = babyDoc.data['parent'];
    if(widget.babyDoc["parent"]!=widget.userEntry){
      print(widget.userEntry);
      print(userID);
      print("User is not parent");
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
      /*
      DocumentReference baby = FirebaseFirestore.instance.doc(widget.baby);
      await baby.update({
        "caretaker": FieldValue.arrayUnion([userID])
      });
      */
    }
    else{
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
