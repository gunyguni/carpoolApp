
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/login.dart';
import 'package:handongcarpool/screens/profile_edit.dart';
import 'package:handongcarpool/service/auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {

  User users = FirebaseAuth.instance.currentUser;
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<TheUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileEdit()));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () async {
              await _auth.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
               Padding(
                 padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                 child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.url),
                            ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('학번: '),
                                  Text(user.stunum, style: TextStyle(fontSize: 20, color: Colors.white),),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Text('휴대폰: '),
                                  Text(user.phoneNo, style: TextStyle(fontSize: 20, color: Colors.white),),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('내가 신청한 카풀목록'),
                      SizedBox(height: 30,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('From handong'),
                              ],
                            ),
                            SizedBox(height: 102,),
                            Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Text('To handong'),
                              ],
                            ),
                            SizedBox(height: 102,),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
