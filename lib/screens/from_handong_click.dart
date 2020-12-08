import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';

class DetailedFromPage extends StatefulWidget {
  final Post post;

  DetailedFromPage({Key key, this.post}) : super(key: key);
  @override
  _DetailedFromPageState createState() => _DetailedFromPageState();
}

class _DetailedFromPageState extends State<DetailedFromPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Handong'),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 50, 40, 10),
            child: Center(
              child: Text(
                widget.post.title,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "연락처: " + widget.post.phoneNo,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "도착지: " + widget.post.destination,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "시간: " + widget.post.time,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                    ),
                    Text(
                      " 현재 카풀 신청 인원: 0/${widget.post.people}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 100,
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_add),
                    SizedBox(
                      width: 20,
                    ),
                    Text('카풀 받기',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            height: 20,
            indent: 20,
            endIndent: 20,
            thickness: 1,
          ),
          //stream을 listview로 받아오기
        ],
      ),
    );
  }
}
