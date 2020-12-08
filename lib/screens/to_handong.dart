import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/post.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/add_page_from.dart';
import 'package:handongcarpool/screens/add_page_to.dart';
import 'package:handongcarpool/service/auth.dart';
import 'package:handongcarpool/widgets/post_tile.dart';
import 'package:provider/provider.dart';

class ToHandong extends StatelessWidget {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('카풀 게시판'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Lo'),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemTo()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('toHGU').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if ((snapshot.hasError) || (snapshot.data == null)) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final posts = _listTiles(context, snapshot.data.docs) ?? [];
            print(posts);

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostTile(
                  post: posts[index],
                );
              },
            );
          }),
    );
  }

  List<Post> _listTiles(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot == null) {
      return null;
    } else {
      return snapshot.map((doc) {
        return Post(
          uid: doc.get('uid') ?? '',
          title: doc.get('title') ?? '',
          phoneNo: doc.get('phoneNo') ?? '',
          people: doc.get('people') ?? 0,
          destination: doc.get('destination') ?? '',
          time: doc.get('time') ?? 0,
        );
      }).toList();
    }
  }
}

// class Post {
//   final String uid;
//   final String title;
//   final String phoneNo;
//   final String destination;
//   final int time;
//   final int people;
//   final DocumentReference reference;

//   Post.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['uid'] != null),
//         assert(map['title'] != null),
//         assert(map['phoneNo'] != null),
//         // assert(map['description'] != null),
//         // assert(map['created'] != null),
//         // assert(map['updated'] != null),

//         uid = map['uid'],
//         title = map['title'],
//         phoneNo = map['phoneNo'],
//         destination = map['destination'],
//         time = map['time'],
//         people = map['people'];

//   Post.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data(), reference: snapshot.reference);
// }
