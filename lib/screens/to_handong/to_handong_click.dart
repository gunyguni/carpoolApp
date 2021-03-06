import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/ShowProfilePicture.dart';
import 'package:handongcarpool/widgets/reply_tile.dart';
import 'package:provider/provider.dart';

class DetailedToPage extends StatefulWidget {
  final Post post;

  DetailedToPage({Key key, this.post}) : super(key: key);
  @override
  _DetailedToPageState createState() => _DetailedToPageState();
}

class _DetailedToPageState extends State<DetailedToPage> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<TheUser>(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: widget.post.reference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.data.data() == null) {
            return Center(child: CircularProgressIndicator());
          }
          //해당 카풀을 신청한 사람의 uid 저장
          List likedUid = snapshot.data.get('likedUid') ?? [];
          return Scaffold(
            appBar: AppBar(
              title: Text('To Handong'),
              centerTitle: true,
              backgroundColor: Colors.black38,
              actions: [
                IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (_user.uid == widget.post.uid) {
                      widget.post.reference.delete();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("타인의 게시물은 지울 수 없습니다."),
                        ),
                      );
                    }
                  },
                ),
              ],
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePicture(
                            pictureURL: widget.post.url,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 150,
                      child: Image.network(
                        widget.post.url,
                        width: 150,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Colors.grey[600],
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(80, 10, 40, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "이름: " + widget.post.username,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "연락처: " + widget.post.phoneNo,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "출발지: " + widget.post.destination,
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
                            .doc(_user.uid)
                            .delete();
                        // 그 후 현재 카풀 신청 인원을 1 줄임
                        widget.post.reference
                            .update({'replies': FieldValue.increment(-1)});
                        // 현재 user가 취소한 카풀의 post object를 user로부터 제거
                        _user.toPosts.remove(widget.post);
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
                          //해당 글의 subcollection의 클릭한 user의 data 저장하기
                          widget.post.reference
                              .collection('subscribe')
                              .doc(_user.uid)
                              .set({
                            'uid': _user.uid,
                            'username': _user.username,
                            'stunum': _user.stunum,
                            'email': _user.email,
                            'phoneNo': _user.phoneNo,
                            'url': _user.url,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("신청 완료"),
                            ),
                          );
                          //신청한 카풀 post object가 user에게 저장
                          _user.toPosts.add(widget.post);
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
                          borderRadius: BorderRadius.circular(20.0),
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
