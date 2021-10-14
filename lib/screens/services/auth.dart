import 'package:baby_tracker/models/myuser.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges()
    .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anon
  Future signInAnon () async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser((user!));
    } catch(e) {
      print(e.toString());
      return null;
    }

  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  //register with email and password

  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      final uid = user!.uid;

      await FirestoreDatabase().addUser(uid, name);

      return _userFromFirebaseUser(user);
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future getUID() async {
    var currentUser = _auth.currentUser;
    if(currentUser != null) {
      var uid = currentUser.uid;
      return uid;
    } else{
      print("Error auth.dart: Could Not Get User");
      return null;
    }
  }

}