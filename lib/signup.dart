import 'package:Chats/dashboard.dart';
import 'package:Chats/services/auth.dart';
import 'package:Chats/services/database.dart';
import 'package:Chats/services/savedata.dart';
import 'package:Chats/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function togglefunction;

  SignUp(this.togglefunction);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  Authentication authentication = new Authentication();
  Database database = new Database();
  SaveData saveData = new SaveData();
  Validator validator = new Validator();

  signUpp() {
    if (formkey.currentState.validate()) {
      Map<String, String> user = {"uname": username.text, 'email': email.text};

      setState(() {
        isLoading = true;
      });

      authentication.signUpWithEmail(email.text, password.text).then((value) {
        if (value != null) {
          if (value) {
            database.uploadUserInfo(user);
            saveData.setUserName(username.text);
            saveData.setUserEmail(email.text);
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
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[800],
                    Colors.orange[600],
                    Colors.orange[400]
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 50,
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
              margin: EdgeInsets.only(top: 120),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '1. Username should not have special characters or digits\n2. Whitespaces are not considered\n3. Username must be between 1 to 11 characters',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                                  return validator
                                      .usernameValidator(value.trim());
                                },
                                controller: username,
                                decoration: InputDecoration(
                                  hintText: 'Enter Username',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
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
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  return validator
                                      .passwordValidator(value.trim());
                                },
                                controller: password,
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        signUpp();
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange[800],
                        ),
                        child: Center(
                          child: Text(
                            'SIGN UP',
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
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.white),
                              children: [
                            TextSpan(
                                text: 'SIGN IN',
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
