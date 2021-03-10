import 'dart:ui';

import 'package:Chats/chatwindow.dart';
import 'package:Chats/search.dart';
import 'package:Chats/services/auth.dart';
import 'package:Chats/services/database.dart';
import 'package:Chats/services/savedata.dart';
import 'package:Chats/toggleScreen.dart';
import 'package:Chats/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Authentication authentication = new Authentication();
  Database database = new Database();
  SaveData saveData = new SaveData();

  Stream chatMessages;

  Widget printChatMessages() {
    return StreamBuilder(
      stream: chatMessages,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatWindow(chatid: ds['chatid'],)));
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: 12, right: 10, left: 10, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.only(left: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue[500],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                '${ds['chatid'].toString().replaceAll('_', '').replaceAll(UserInfo.userName, '').substring(0, 1).toUpperCase()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '@' +
                                ds['chatid']
                                    .toString()
                                    .replaceAll('_', '')
                                    .replaceAll(UserInfo.userName, ''),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    UserInfo.userName = await saveData.getUserName();
    database.getChats(UserInfo.userName).then((value) {
      setState(() {
        chatMessages = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.orange[200],
        bottomOpacity: 0.0,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.blue,
            ),
            onPressed: () {
              authentication.signOut();
              saveData.setUserLogIn(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ToggleScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Icon(Icons.search),
        elevation: 2,
        shape:
            CircleBorder(side: BorderSide(color: Colors.orange[200], width: 3)),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(color: Colors.black, child: printChatMessages()),
      ),
    );
  }
}
