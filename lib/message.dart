import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;

  final bool isMyMessage;

  Message({this.message, this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(17),
      padding: EdgeInsets.only(right: isMyMessage ? 5 : 0, left: isMyMessage ? 0 : 5),
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.orange[200] : Colors.blue[200],
          borderRadius: isMyMessage
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))
              : BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
        ),
        child: Text(message, style: TextStyle(
          fontSize: 17,
        ),),
      ),
    );
  }
}
