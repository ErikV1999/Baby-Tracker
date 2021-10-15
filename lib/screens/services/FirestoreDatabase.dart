import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/services/auth.dart';

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

  Future<void> addBaby(String name, String gender, int feet, int inches, DateTime date) async {
    final uid = await AuthService().getUID();
    CollectionReference babies = users.doc(uid).collection('Babies');

    int dob = date.millisecondsSinceEpoch;

    await babies.add({
      'Name': name,
      'gender': gender,
      'feet': feet,
      'inches': inches,
      'dob': dob,
      'Diaper': 'N/A',
      'Feeding': 'N/A',
      'Sleeping': 'N/A',
    })
        .then((value) => print('Baby Added'))
        .catchError((error) => print("Failed to add baby"));
  }

  Future<void> addSleepTime(int start, int stop, String notes) async {
    final uid = await AuthService().getUID();

    CollectionReference sleeping = users.doc(uid).collection('Babies').doc('KTthHOHEVbwaMtxutRzW').collection('sleeping');

    await sleeping.add({
      'Start': start,
      'Stop': stop,
      'Notes': notes,
    })
        .then((value) => print('Sleep Added'))
        .catchError((error) => print("Failed to add sleeping data"));
  }

}