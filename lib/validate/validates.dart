final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

String? validateEmail(String value) {
  if (value.isEmpty) {
    return "Please enter sometext! ";
  } else if (!emailRegExp.hasMatch(value)) {
    return "Email is incorrect! ";
  }
  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return "Please enter sometext! ";
  } else if (value.length < 6) {
    return "Please enter more than 6 characters !";
  }
  return null;
}

String? validateVerifyPassword(String password, String repassword) {
  if (repassword.isEmpty) {
    return "Please enter sometext! ";
  } else if (repassword.length < 6) {
    return "Please enter more than 6 characters !";
  } else if (repassword != password) {
    return "  Unmatched password !";
  }
  return null;
}

String? validateStringNotEmty(String value) {
  if (value.isEmpty) {
    return "Please enter sometext! ";
  }
  return null;
}

String? validatePhone(String? value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{9,10}$)';

  RegExp regExp = RegExp(patttern);
  if (value != null) {
    if (value.isEmpty) {
      return "\t\tVui lòng không để trống! \n";
    } else {
      if (!regExp.hasMatch(value)) {
        return "\t\tVui lòng số điện thoại đúng \n";
      }
    }
  }
  return null;
}
