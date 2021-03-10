import 'package:Chats/message.dart';
import 'package:Chats/services/database.dart';
import 'package:Chats/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  final String chatid;

  ChatWindow({this.chatid});

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  TextEditingController message = new TextEditingController();

  Database database = new Database();

  Stream messages;

  sendMessages() {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': message.text,
        'sendby': UserInfo.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      database.setMessages(widget.chatid, messageMap);
      message.text = '';
    }
  }

  Widget messagesStreamList() {
    return StreamBuilder(
      stream: messages,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70),
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Message(
                    message: ds['message'],
                    isMyMessage: ds['sendby'] == UserInfo.userName,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    database.getMessages(widget.chatid).then((value) {
      setState(() {
        messages = value;
      });
    });
    super.initState();
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
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Container(
                  // height: MediaQuery.of(context).size.height - 150,
                  margin: EdgeInsets.only(bottom: 20),
                  child: messagesStreamList()),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 12, 5, 12),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange[200],
                        width: 2
                      ),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                            hintText: 'message',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessages();
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 5, left: 5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.orange[200],
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
