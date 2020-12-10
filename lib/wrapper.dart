import 'package:cloud_firestore/cloud_firestore.dart';
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
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data.data() == null) {
              //print(snapshot.data.get('phonenum'));
              return PersonInformation();
            } else {
              user.phoneNo = snapshot.data.get('phonenum');
              print(user.phoneNo);
              return HomePage();
            }
          });
    }

    if (user == null) {
      return LoginPage();
      // }
      // else if (FirebaseFirestore.instance
      //         .collection('user')
      //         .where('uid', isEqualTo: user.uid)
      //         .snapshots() ==
      //     null) {
      //   return PersonInformation();
    } else {
      return PersonInformation();
    }
  }
}