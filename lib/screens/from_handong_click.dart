import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:provider/provider.dart';

class DetailedFromPage extends StatefulWidget {
  final Post post;

  DetailedFromPage({Key key, this.post}) : super(key: key);
  @override
  _DetailedFromPageState createState() => _DetailedFromPageState();
}

class _DetailedFromPageState extends State<DetailedFromPage> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<TheUser>(context);
    //나중엔 Firebase로 연동할 예정
    List<TheUser> list = [
      TheUser(uid: "21600244", phoneNo: "01012341234"),
      TheUser(uid: "21300123", phoneNo: "01012344432"),
      TheUser(uid: "21500342", phoneNo: "01034123434"),
      TheUser(uid: "21400432", phoneNo: "01023459195"),
      TheUser(uid: "21400432", phoneNo: "01023459195"),
    ];

    //////////////////// 여기서 어떻게 해야 subcollection에 있는
    ///snapshot들을 모아 TheUser의 list로 만들 수 있을까 고민해야 됌
    // widget.post.reference.collection('subscribe').doc()
    // });

    //만약 subcollection을 적용한 뒤에 이 화면이 바뀌지 않으면 document snapshot의 stream을 subcollection으로
    // 바꿔야 할수도 있음
    return StreamBuilder<DocumentSnapshot>(
        stream: widget.post.reference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.data.data() == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('From Handong'),
              centerTitle: true,
              backgroundColor: Colors.black38,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                    child: Center(
                      child: Text(
                        widget.post.title,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                              " 현재 카풀 신청 인원: ${snapshot.data.get('replies')}/${widget.post.people}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    //카풀 받기 버튼 누르면 subcollection에 추가
                    onTap: () {
                      List likedUid = snapshot.data.get('likedUid');
                      if (snapshot.data.get('replies') >=
                          snapshot.data.get('people')) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("이미 신청 인원이 마감되었습니다 ㅜㅜ"),
                        ));
                      } else if (!likedUid.contains(_user.uid)) {
                        //한번 신청한 사람의 uid를 저장하기 (중복 클릭 방지용)
                        widget.post.reference
                            .update({'replies': FieldValue.increment(1)});
                        likedUid.add(_user.uid);
                        widget.post.reference.update({'likedUid': likedUid});
                        //해당 글의 subcollection의 클릭한 사람 이름 저장하기
                        widget.post.reference
                            .collection('subscribe')
                            .add({'uid': '21600244', 'phoneNo': '01012345678'});

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("신청 완료"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("이미 해당 카풀을 신청 했습니다 ㅜㅜ"),
                        ));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                  ///////////////////////////////////// 여기 해야 됌
                  // subcollection을 listview로 받아오기
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _replyCard(list[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _replyCard(TheUser user) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(user.uid),
      subtitle: Text(user.phoneNo),
    );
  }
}
