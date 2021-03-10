import 'package:shared_preferences/shared_preferences.dart';

class SaveData{

  Future setUserLogIn(bool isUserLogIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool('ISUSERLOGIN', isUserLogIn);
  }

  Future setUserName(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString('USERNAME', username);
  }

  Future setUserEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString('USEREMAIL', email);
  }

    Future getUserLogIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('ISUSERLOGIN');
  }

  Future getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('USERNAME');
  }

  Future getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('USEREMAIL');
  }
}