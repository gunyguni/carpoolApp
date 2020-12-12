import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/ShowProfilePicture.dart';
import 'package:handongcarpool/screens/from_handong/from_handong.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ReplyTile extends StatefulWidget {
  final Post post;
  ReplyTile({Key key, this.post}) : super(key: key);

  @override
  _ReplyTileState createState() => _ReplyTileState();
}

class _ReplyTileState extends State<ReplyTile> {
  //detailed page를 click할 시 밑의 댓글들이 실시간 update 되는 listview builder다.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.post.reference.collection('subscribe').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if ((snapshot.hasError) || (snapshot.data == null)) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final list = _listReplies(context, snapshot.data.docs) ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return _replyCard(list[index]);
            },
          );
        });
  }

  List<TheUser> _listReplies(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot == null) {
      return null;
    } else {
      return snapshot.map((data) {
        return TheUser(
          uid: data.get('uid'),
          username: data.get('username'),
          stunum: data.get('stunum'),
          phoneNo: data.get('phoneNo'),
          url: data.get('url'),
          email: data.get('email'),
        );
      }).toList();
    }
  }

  Widget _replyCard(TheUser user) {
    return ListTile(
      //아이콘 circle avatar로 바꿈
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePicture(
                pictureURL: user.url,
              ),
            ),
          );
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.url),
          ),
        ),
      ),
      title: Text(user.username + '(${user.stunum})'),
      subtitle: Text('연락처: ' + user.phoneNo + '\n이메일: ' + user.email),
    );
  }
}
