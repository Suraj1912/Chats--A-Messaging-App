import 'package:Chats/services/auth.dart';
import 'package:Chats/services/database.dart';
import 'package:Chats/services/savedata.dart';
import 'package:Chats/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class SignIn extends StatefulWidget {
  final Function togglefunction;

  SignIn(this.togglefunction);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  Authentication authentication = new Authentication();
  Database database = new Database();
  SaveData saveData = new SaveData();
  Validator validator = new Validator();

  QuerySnapshot querySnapshot;

  signInn() {
    if (formkey.currentState.validate()) {
      saveData.setUserEmail(email.text);

      database.fetchUserEmailFromDatabase(email.text).then((value) {
        querySnapshot = value;
        saveData.setUserName(querySnapshot.docs[0].data()['uname']);
      });

      setState(() {
        isLoading = true;
      });

      authentication.signInWithEmail(email.text, password.text).then((value) {
        if (value != null) {
          if (value) {
            saveData.setUserLogIn(true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          } else {
            _scaffoldkey.currentState.showSnackBar(SnackBar(
              content: Text(
                authentication.error,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontSize: 15,
                ),
              ),
              backgroundColor: Colors.orange[200],
              duration: Duration(seconds: 7),
            ));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.orange[800],
                Colors.orange[600],
                Colors.orange[400]
              ])),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border.all(width: 3, color: Colors.orange[200]),
              ),
              margin: EdgeInsets.only(top: 150),
              child: Padding(
                padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.orange[200]),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(225, 97, 27, .2),
                              blurRadius: 20,
                              offset: Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                validator: (value) {
                                  return validator.emailValidator(value.trim());
                                },
                                controller: email,
                                decoration: InputDecoration(
                                  hintText: 'Enter Email id',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                obscureText: true,
                                // validator: (value) {
                                //   return validator.passwordValidator(value.trim());
                                // },
                                controller: password,
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        signInn();
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange[800],
                        ),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.white),
                              children: [
                            TextSpan(
                                text: 'SIGN UP',
                                style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    widget.togglefunction();
                                  }),
                          ])),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
