import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String pictureURL;
  ProfilePicture({Key key, this.pictureURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Center(child: Image.network(pictureURL)));
  }
}
