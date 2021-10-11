import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  //adds user to database and uses user's Firebase Auth uid as its document id
  Future<void> addUser(String uid, String name) async {

    return users.doc(uid).set({
      'name': name,
      'caretaking': [],
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }



}