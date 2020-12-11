import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:provider/provider.dart';

class AddItemTo extends StatefulWidget {
  @override
  _AddItemToState createState() => _AddItemToState();
}

class _AddItemToState extends State<AddItemTo> {
  TextEditingController _title = TextEditingController();
  TextEditingController _people = TextEditingController();
  TextEditingController _destination = TextEditingController();
  TextEditingController _time = TextEditingController();
  CollectionReference post = FirebaseFirestore.instance.collection('toHGU');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('카풀 인원 모집하기'),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                Navigator.pop(context);
                await post.add({
                  'uid': user.uid,
                  'title': _title.text,
                  'phoneNo': user.phoneNo,
                  'people': int.parse(_people.text),
                  'destination': _destination.text,
                  'time': _time.text,
                  'likedUid': <String>[],
                  'replies': 0,
                  'url': user.url,
                });
              } catch (e) {
                print(e.toString());
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _title,
                decoration: InputDecoration(
                  labelText: '제목',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _people,
                decoration: InputDecoration(
                  labelText: '총 인원',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _destination,
                decoration: InputDecoration(
                  labelText: '출발지',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _time,
                decoration: InputDecoration(
                  labelText: '시간',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
