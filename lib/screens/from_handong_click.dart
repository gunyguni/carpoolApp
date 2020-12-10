import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/widgets/reply_tile.dart';
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
    // List<TheUser> list = [
    //   TheUser(uid: "21600244", phoneNo: "01012341234"),
    //   TheUser(uid: "21300123", phoneNo: "01012344432"),
    //   TheUser(uid: "21500342", phoneNo: "01034123434"),
    //   TheUser(uid: "21400432", phoneNo: "01023459195"),
    //   TheUser(uid: "21400432", phoneNo: "01023459195"),
    // ];

    //////////////////// 여기서 어떻게 해야 subcollection에 있는
    ///snapshot들을 모아 TheUser의 list로 만들 수 있을까 고민해야 됌

    return StreamBuilder<DocumentSnapshot>(
        stream: widget.post.reference.snapshots(),
        builder: (context, snapshot) {
          //해당 카풀을 신청한 사람의 uid 저장
          List likedUid = snapshot.data.get('likedUid');
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
                    onTap: () {
                      // 카풀 취소 버튼 누르면 subcollection에서 제거
                      if (likedUid.contains(_user.uid)) {
                        widget.post.reference
                            .collection('subscribe')
                            .doc(snapshot.data.get('uid'))
                            .delete();
                        // 그 후 현재 카풀 신청 인원을 1 줄임
                        widget.post.reference
                            .update({'replies': FieldValue.increment(-1)});
                        // 마지막으로 현재 카풀을 신청한 uid list에서 현재 user의 uid를 제거함
                        likedUid.remove(_user.uid);
                        widget.post.reference.update({'likedUid': likedUid});
                      } else {
                        //카풀 받기 버튼 누르면 subcollection에 추가
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
                              .doc(snapshot.data.get('uid'))
                              .set({
                            'uid': '21600244',
                            'phoneNo': _user.phoneNo,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("신청 완료"),
                          ));
                        } else {
                          //카풀을 이미 신청한 경우. 이는 우리가 디자인적으로 극복해서 굳이 처리할 필요가
                          // 없는 exception case이기 때문에 지워도 되지만 혹시 모르니 일단 놔둠
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("이미 해당 카풀을 신청 했습니다 ㅜㅜ"),
                          ));
                        }
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
                            likedUid.contains(_user.uid)
                                ? Icon(Icons.person_add_disabled)
                                : Icon(Icons.person_add),
                            SizedBox(
                              width: 20,
                            ),
                            // 만약 카풀 신청했다면 버튼이 바뀜
                            likedUid.contains(_user.uid)
                                ? Text('카풀 취소',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))
                                : Text('카풀 받기',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))
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
                  // subcollection을 listview로 받아오기

                  ReplyTile(post: widget.post),
                ],
              ),
            ),
          );
        });
  }
}
