class UserDetail {
  String uid;
  String name;
  String email;
  String urlAvatar;
  String phoneNumber;
  String address;
  UserDetail(this.uid, this.name, this.email, this.urlAvatar, this.phoneNumber,
      this.address);
  UserDetail.fromJson(Map<dynamic, dynamic> json)
      : uid = json["uid"],
        name = json['name'],
        email = json['email'],
        urlAvatar = json["urlAvatar"],
        phoneNumber = json["phoneNumber"],
        address = json["address"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        'name': name,
        'email': email,
        "urlAvatar": urlAvatar,
        "phoneNumber": phoneNumber,
        "address": address,
      };
}
