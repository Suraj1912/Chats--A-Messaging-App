import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  fetchUserFromDatabase(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('uname', isEqualTo: username)
        .get();
  }

  fetchUserEmailFromDatabase(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }


  uploadUserInfo(user) {
    FirebaseFirestore.instance.collection('users').doc(user['uname']).set(user);
  }

  setChatDetails(String chatid, usermap) {
    FirebaseFirestore.instance
        .collection('chatWindow')
        .doc(chatid)
        .set(usermap)
        .catchError((e) {
      print(e.toString());
    });
  }

  setMessages(String chatid, message) {
    FirebaseFirestore.instance
        .collection('chatWindow')
        .doc(chatid)
        .collection('chats')
        .add(message)
        .catchError((e) => print(e.toString()));
  }

  getMessages(String chatid) async {
    return FirebaseFirestore.instance
        .collection('chatWindow')
        .doc(chatid)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  getChats(String username) async {
    return FirebaseFirestore.instance
        .collection('chatWindow')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
