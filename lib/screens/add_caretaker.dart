import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCaretaker extends StatefulWidget {

  final String baby;
  final String userEntry;
  final String parent;
  const AddCaretaker({Key? key, required this.baby, required this.userEntry, required this.parent}) : super(key: key);

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
                  onPressed:  () async{
                    //dynamic babyDoc = await FirebaseFirestore.instance.doc(widget.baby).snapshots();
                    //String babyParent = babyDoc.data['parent'];
                    if(widget.parent!=widget.userEntry){
                      print(widget.userEntry);
                      print(userID);
                      print("User is not parent");
                      return;
                    }
                    bool valid = await validateUser(userID);
                    print(userID);
                    if(valid) {
                      DocumentReference baby = FirebaseFirestore.instance.doc(widget.baby);
                      await baby.update({
                        "caretaker": FieldValue.arrayUnion([userID])
                      });
                    }
                    else{
                      print("invalid");
                    }
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
