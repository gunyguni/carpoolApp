import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddItemTo extends StatefulWidget {
  @override
  _AddItemToState createState() => _AddItemToState();
}

class _AddItemToState extends State<AddItemTo> {
  TextEditingController _title = TextEditingController();
  TextEditingController _people = TextEditingController();
  TextEditingController _destination = TextEditingController();
  //현재 시간으로 초기화한 time
  String _selectedTime =
      Duration(hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().hour)
              .toString()
              .split(':')
              .first
              .padLeft(2, "0") +
          ':' +
          Duration(hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().hour)
              .toString()
              .split(':')
              .elementAt(1)
              .padLeft(2, "0");
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
                  'time': _selectedTime,
                  'likedUid': <String>[],
                  'replies': 0,
                  'url': user.url,
                  'timeStamp': Timestamp.now(),
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
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              color: Colors.grey,
              icon: Icon(Icons.watch_later),
              label: Text('시간 고르기', style: TextStyle(fontWeight: FontWeight.bold),),
              onPressed: () {
                Future<TimeOfDay> selectedTime = showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                selectedTime.then((timeOfDay) {
                  setState(() {
                    _selectedTime = Duration(
                                hours: timeOfDay.hour,
                                minutes: timeOfDay.minute)
                            .toString()
                            .split(':')
                            .first
                            .padLeft(2, "0") +
                        ':' +
                        Duration(
                                hours: timeOfDay.hour,
                                minutes: timeOfDay.minute)
                            .toString()
                            .split(':')
                            .elementAt(1)
                            .padLeft(2, "0");
                  });
                });
              },
            ),
            Text(
              '시간: ' + _selectedTime,
              style: TextStyle(
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
