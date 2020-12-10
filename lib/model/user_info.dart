import 'package:handongcarpool/model/post.dart';

class TheUser {
  final String uid;
  String email;
  String phoneNo;
  String stunum;
  String url;
  List<Post> fromPosts;
  List<Post> toPosts;

  TheUser(
      {this.uid,
      this.email,
      this.phoneNo,
      this.stunum,
      this.url,
      this.fromPosts});
}
