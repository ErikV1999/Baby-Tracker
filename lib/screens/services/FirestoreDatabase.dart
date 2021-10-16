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
      'Sleeping': 0,
    })
        .then((value) => print('Baby Added'))
        .catchError((error) => print("Failed to add baby"));
  }

  Future<void> addSleepTime(int startHour, int startMin, int stopHour, int stopMin, int month, int day, int year, String notes, String path) async {
    final uid = await AuthService().getUID();

    CollectionReference sleeping = users.doc(uid).collection('Babies').doc(path).collection('sleeping');
    CollectionReference lastSleeping = users.doc(uid).collection('Babies');

    await sleeping.add({
      'StartHour': startHour,
      'StartMin': startMin,
      'StopHour': stopHour,
      'StopMin': stopMin,
      'Month': month,
      'Day': day,
      'Year': year,
      'Notes': notes,
    })
        .then((value) => print('Sleep Added'))
        .catchError((error) => print("Failed to add sleeping data"));
  }
  Future<void> updateLastSleep(int totalSleep, String path) async {
    final uid = await AuthService().getUID();
    users
      .doc(uid)
      .collection('Babies')
      .doc(path)
      .update({'Sleeping': totalSleep})
      .then((value) => print('Last Sleep Updated'))
      .catchError((error) => print("Failed to add sleeping data"));
  }

}