import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/invites.dart';

class AddCaretaker extends StatefulWidget {

  final String baby;      //baby path
  final String userEntry;   //users doc ID
  final dynamic babyDoc;    //full baby doc form the db
  const AddCaretaker({Key? key, required this.baby, required this.userEntry, required this.babyDoc}) : super(key: key);

  @override
  State<AddCaretaker> createState() => _AddCaretakerState();
}

/*
This is the class for the screen for sending caretaker invites. Contains a textbox
and an add button.

Takes a "baby" which is the baby path
userEntry which is the users doc ID
babyDoc which is the full document from the database for the baby
 */
class _AddCaretakerState extends State<AddCaretaker> {

  String userInputID = "";                          //defaul value for the variable that holds the user input ID
  dynamic msgController = TextEditingController();  //allows for other components and functions to control the text box

  /*
  This functino is used to validate the input user display ID is valid
  Takes a user ID as input.
  outputs a future boolean
   */
  static Future<bool> validateUser(String userID) async {
    bool exists = false;            //tells if the user exists
    try {
      await FirebaseFirestore.instance
          .collection("DisplayNames")     //looks through display names
          .doc(userID)                    //gets the userID document
          .get()
      .then((doc) {
        if (doc.exists)             //if it worked, return true
          exists = true;
        else                        //else it doesnt exist
          exists = false;
      });
      return exists;
    } catch (e) {
      return exists;            //uses default of false if it fails
    }
  }
  /*
  A function that fires when the add button is pressed
  Takes no input and has no output.
  verifies the input is valid, sends the message to the database, then alerts the user of the result
   */
  void addPressed() async{

    if(widget.babyDoc["parent"]!=widget.userEntry){   //ensures the user is the parent of the child

      print("User is not parent");                    //tells the user they arent the parent
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
    bool valid = await validateUser(userInputID);       //finds out if hte user exists

    if(valid) {                                         //user is valid
      CollectionReference invites = FirebaseFirestore.instance.collection("Invites");

      await invites.add({                               //add invite for the caretaker to see
        "babyPath" : widget.baby,
        "receiver" : userInputID,
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
      setState(()=>userInputID = "");                //sets variable to clear
      msgController.clear();                        //clear the userinput bar

    }
    else{                                           //user is not valid
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
    Color bannerColor = Color(0xFF006992);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bannerColor,
      ),
      body: Container(
        child: Form(
          child: ListView(
            children: [
              TextFormField(                    //takes user input
                controller: msgController,      //allows it to be controlled externally
                decoration: InputDecoration(
                  labelText: "users ID: ",

                ),
                onChanged: (val) {              //changes the internal veriable of the text when form changes
                  setState(() => userInputID = val);
                }
              ),
              Container(
                  child: ElevatedButton(
                  child: Text("Add"),
                  onPressed: () async {         //runs the pressed function
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
