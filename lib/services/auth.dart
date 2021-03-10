import 'package:Chats/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserId _userId(User user) {
    return user == null ? null : UserId(userId: user.uid);
  }

  String error;

  Future signInWithEmail(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      error = '';
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;
      return false;
    }
  }

  Future signUpWithEmail(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      error = '';
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;
      return false;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
