import 'package:handongcarpool/model/post.dart';

class TheUser {
  final String uid;
  String email;
  String phoneNo;
  String stunum;
  String username;
  String url;
  List<Post> fromPosts;
  List<Post> toPosts;

  TheUser(
      {this.uid,
      this.email,
      this.phoneNo,
      this.stunum,
      this.username,
      this.url,
      this.fromPosts});
}
