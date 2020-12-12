import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/login.dart';
import 'package:handongcarpool/screens/profile.dart';
import 'package:handongcarpool/service/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  User users = FirebaseAuth.instance.currentUser;
  AuthService _auth = AuthService();
  bool uploaded = false;
  File _eimage;
  final picker = ImagePicker();
  @override
  Future editgetImageFromCamera() async {
    final editpickedFileCam = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (editpickedFileCam != null) {
        _eimage = File(editpickedFileCam.path);
        uploaded = true;
      }
    });
  }

  Future editgetImageFromGallery() async {
    final editpickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (editpickedFile != null) {
        _eimage = File(editpickedFile.path);
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
                      editgetImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('갤러리'),
                    onTap: () {
                      editgetImageFromGallery();
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
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    TextEditingController _phoneeditController =
        TextEditingController(text: user.phoneNo);
    TextEditingController _stunumeditController =
        TextEditingController(text: user.stunum);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child('user');
    String url = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 편집'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            color: Colors.white,
            onPressed: () async {
              if (_eimage != null) {
                await ref.putFile(_eimage);
                url = (await ref.getDownloadURL()).toString();
              } else {
                url = user.url;
              }
              await userinfo
                  .doc(user.uid)
                  .update({
                    'uid': user.uid,
                    'phonenum': _phoneeditController.text,
                    'email': FirebaseAuth.instance.currentUser.email,
                    'url': url,
                    'stunum': _stunumeditController.text
                  })
                  .then((value) => print('Item added'))
                  .catchError((error) => print('Failed add Item : $error'));
              print(user.phoneNo);
              uploaded = false;
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()))
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.black,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: _eimage == null
                                        ? NetworkImage(user.url)
                                        : FileImage(_eimage),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 2, color: Colors.black)),
                                      child: Icon(
                                        Icons.add_a_photo,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('학번: '),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 120,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          focusColor: Colors.white,
                                        ),
                                        controller: _stunumeditController,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text('휴대폰: '),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 110,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          focusColor: Colors.white,
                                        ),
                                        controller: _phoneeditController,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
