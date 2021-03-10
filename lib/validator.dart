
class Validator {
  emailValidator(String value) {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)
        ? null
        : 'Please provide valid email id';
  }

  passwordValidator(String value) {
    return value.length < 8 ? 'Password must be 8 characters long' : null;
  }

  usernameValidator(String value) {
    // Database().checkExist(value);
    return value.isEmpty ||
            value.length > 15 ||
            !(RegExp(r"^[A-Za-z]+$").hasMatch(value))
        ? 'Username is invalid'
        : null;
  }
}
