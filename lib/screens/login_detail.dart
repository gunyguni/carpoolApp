import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/service/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PersonInformation extends StatefulWidget {
  @override
  _PersonInformationState createState() => _PersonInformationState();
}

class _PersonInformationState extends State<PersonInformation> {
  TextEditingController _phoneController = TextEditingController();
  bool uploaded = false;
  File _image;
  final picker = ImagePicker();
  @override
  Future getImageFromGallery(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploaded = true;
      }
    });
  }

  CollectionReference userinfo = FirebaseFirestore.instance.collection('user');
  // Future<void> addInformation() async {
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('user');
  //   final user = Provider.of<TheUser>(context);
  //   await ref.putFile(_image);
  //   String url = (await ref.getDownloadURL()).toString();
  //   await userinfo.doc().set({'uid': user.uid, 'phonenum': _phoneController.text, 'email': user.email, 'url': url}).then((value) => print('Item added')).catchError((error) => print('Failed add Item : $error'));
  // }
  Widget build(BuildContext context) {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child('user');
    final user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Put phone no, Profile'),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await ref.putFile(_image);
              String url = (await ref.getDownloadURL()).toString();
              await userinfo
                  .doc()
                  .set({
                    'uid': user.uid,
                    'phonenum': _phoneController.text,
                    'email': FirebaseAuth.instance.currentUser.email,
                    'url': url
                  })
                  .then((value) => print('Item added'))
                  .catchError((error) => print('Failed add Item : $error'));

              uploaded = false;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Center(
                    child: _image == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                'https://www.handong.edu/site/handong/res/img/splash-1199.png'),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ),
                          )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    getImageFromGallery(ImageSource.gallery);
                  },
                )
              ],
            ),
            Container(
              width: 270,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '휴대폰 번호',
                      focusColor: Colors.white,
                    ),
                    controller: _phoneController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
