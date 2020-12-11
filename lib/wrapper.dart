import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData && snapshot.data.data() != null) {
              user.phoneNo = snapshot.data.get('phonenum');
              user.email = FirebaseAuth.instance.currentUser.email ?? '';
              user.stunum = snapshot.data.get('stunum');
              user.url = snapshot.data.get('url');
              user.fromPosts = [];
              user.toPosts = [];
              return HomePage();
            } else {
              // 만약 유저의 data가 없으면 정보 입력 화면으로 간다.
              return PersonInformation();
            }
          });
    }
  }
}
