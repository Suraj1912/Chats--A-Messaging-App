import 'package:Chats/services/database.dart';
import 'package:Chats/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:Chats/chatwindow.dart';

class CreateChatWindow {
  createChatWindow(BuildContext context, String username) {
    String chatID = getChatID(username, UserInfo.userName);

    List<String> users = [username, UserInfo.userName];

    Map<String, dynamic> userMap = {'chatid': chatID, 'users': users};
    Database().setChatDetails(chatID, userMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatWindow(
                  chatid: chatID, 
                )));
  }

  getChatID(String user1, String user2) {
    if (user1.substring(0, 1).codeUnitAt(0) >
        user2.substring(0, 1).codeUnitAt(0)) {
      return '$user2\_$user1';
    } else {
      return '$user1\_$user2';
    }
  }
}
