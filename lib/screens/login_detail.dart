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
  TextEditingController _stunumController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  bool uploaded = false;
  File _image;
  final picker = ImagePicker();
  @override
  Future getImageFromCamera() async {
    final pickedFileCam = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFileCam != null) {
        _image = File(pickedFileCam.path);
        uploaded = true;
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploaded = true;
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('카메라'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('갤러리'),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
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
    final user = Provider.of<TheUser>(context);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(user.uid);
    String url = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('회원 정보 입력'),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_image != null) {
                await ref.putFile(_image);
                url = (await ref.getDownloadURL()).toString();
              } else {
                url =
                    'https://www.handong.edu/site/handong/res/img/splash-1199.png';
              }

              await userinfo
                  .doc(user.uid)
                  .set({
                    'uid': user.uid,
                    'username': _nameController.text,
                    'phonenum': _phoneController.text,
                    'email': FirebaseAuth.instance.currentUser.email,
                    'url': url,
                    'stunum': _stunumController.text
                  })
                  .then((value) => print('Item added'))
                  .catchError((error) => print('Failed add Item : $error'));

              uploaded = false;
              // print(FirebaseFirestore.instance.collection('user').doc(user.uid).snapshots());
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
                    _showPicker(context);
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
                      hintText: '이름',
                      focusColor: Colors.white,
                    ),
                    controller: _nameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '학번',
                      focusColor: Colors.white,
                    ),
                    controller: _stunumController,
                  ),
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
