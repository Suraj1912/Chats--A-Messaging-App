import 'package:Chats/signin.dart';
import 'package:Chats/signup.dart';
import 'package:flutter/material.dart';

class ToggleScreen extends StatefulWidget {
  @override
  _ToggleScreenState createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {

  bool showSignIn = true;

  void toggleScreenView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleScreenView);
    }
    else{
      return SignUp(toggleScreenView);
    }
  }
}