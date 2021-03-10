import 'package:Chats/dashboard.dart';
import 'package:Chats/services/savedata.dart';
import 'package:Chats/toggleScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SaveData saveData = new SaveData();

  bool isLogIn;

  @override
  void initState() {
    getLogInStatus();
    super.initState();
  }

  getLogInStatus() async {
    await saveData.getUserLogIn().then((value) {
      setState(() {
        isLogIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chats',
      home: isLogIn != null ? isLogIn ? Dashboard() : ToggleScreen() : ToggleScreen(),
      theme: ThemeData(fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
