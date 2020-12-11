import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/screens/from_handong/from_handong.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile({this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Card(
        child: ListTile(
          onTap: () {
            //         Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => 네비게이션할 페이지()),);
          },
          title: Text(post.title),
          subtitle: Text(post.phoneNo),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.person),
              Text('0/' + post.people.toString())
            ],
          ),
        ),
      ),
    );
  }
}
