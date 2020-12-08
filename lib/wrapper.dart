import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/homepage.dart';
import 'package:handongcarpool/screens/login.dart';
import 'package:handongcarpool/screens/login_detail.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either Home or Login widget depending on AuthService.user stream
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return PersonInformation();
    }
  }
}
