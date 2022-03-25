import 'package:flutter/material.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

Widget avatar(String urlAvatar, double size) {
  return UserProfileAvatar(
    avatarUrl: urlAvatar,
    radius: size,
  );
}
