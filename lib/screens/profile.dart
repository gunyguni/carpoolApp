import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/from_handong/from_handong_click.dart';
import 'package:handongcarpool/screens/homepage.dart';
import 'package:handongcarpool/screens/login.dart';
import 'package:handongcarpool/screens/profile_edit.dart';
import 'package:handongcarpool/screens/to_handong/to_handong_click.dart';
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
    if (user == null) {
      return LoginPage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('프로필'),
          centerTitle: true,
          backgroundColor: Colors.grey,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
          },
            ),
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
                //만약 카풀 게시판에 내 프로필이 있다면 pop 2번, home page에 내 프로필이 있다면 pop 1번
                Navigator.pop(context);
                // Navigator.pop(context);
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.url),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('학번: '),
                                  Text(
                                    user.stunum,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text('휴대폰: '),
                                  Text(
                                    user.phoneNo,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('내가 신청한 카풀목록'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text('From handong'),

                    //여기서 부터 From handong
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('fromHGU')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if ((snapshot.hasError) || (snapshot.data == null)) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        final fromposts = user.fromPosts;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: fromposts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedFromPage(
                                                post: fromposts[index],
                                              )), //parameter로 post 넘기기
                                    );
                                  },
                                  title: Text(fromposts[index].title),
                                  subtitle: Text(fromposts[index].phoneNo),
                                  trailing: Column(
                                    children: <Widget>[
                                      Icon(Icons.person),
                                      Text(fromposts[index].replies.toString() +
                                          '/' +
                                          fromposts[index].people.toString())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    //////////////////// 여기까지 fromHandong////////////////
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    Text('To handong'),
                    //여기서부터 To handong
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('toHGU')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if ((snapshot.hasError) || (snapshot.data == null)) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        final toposts = user.toPosts;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: toposts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedToPage(
                                                post: toposts[index],
                                              )), //parameter로 post 넘기기
                                    );
                                  },
                                  title: Text(toposts[index].title),
                                  subtitle: Text(toposts[index].phoneNo),
                                  trailing: Column(
                                    children: <Widget>[
                                      Icon(Icons.person),
                                      Text(toposts[index].replies.toString() +
                                          '/' +
                                          toposts[index].people.toString())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    //////////////////// 여기까지 toHandong////////////////
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
}}