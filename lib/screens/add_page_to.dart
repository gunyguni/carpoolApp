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
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _people = TextEditingController();
  CollectionReference post = FirebaseFirestore.instance.collection('toHGU');
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('To Handong'),
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
                  'phoneNo': _phoneNo.text,
                  'people': int.parse(_people.text),
                  'destination': '',
                  'time': 0
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
                  labelText: '출발지',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _phoneNo,
                decoration: InputDecoration(
                  labelText: '핸드폰 번호',
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
          ],
        ),
      ),
    );
  }
}
