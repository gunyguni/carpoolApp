import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/service/auth.dart';
import 'package:image_picker/image_picker.dart';

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

  CollectionReference uid = FirebaseFirestore.instance.collection('user');
  Future<void> addInformation() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('user');
    await ref.putFile(_image);
    String url = (await ref.getDownloadURL()).toString();
  }
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
