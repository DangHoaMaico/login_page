import 'package:login_page/model/User/user.dart';

class Contact extends UserDetail {
  bool isMark = false;
  Contact(String uid, String name, String email, String urlAvatar,
      String phoneNumber, String address, this.isMark)
      : super(uid, name, email, urlAvatar, phoneNumber, address);

  Contact.fromJson(Map<dynamic, dynamic> json) : super.fromJson(json) {
    phoneNumber = json["phoneNumber"];
    address = json["address"];
    isMark = json["isMark"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "uid": uid,
        'name': name,
        'email': email,
        "urlAvatar": urlAvatar,
        "phoneNumber": phoneNumber,
        "address": address,
        "isMark": isMark
      };
}
