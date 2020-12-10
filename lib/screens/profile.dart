
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handongcarpool/model/user_info.dart';
import 'package:handongcarpool/screens/login.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  User users = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
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
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(users.photoURL.toString()),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        //Text('\<' + user.stunum + '\>', style: TextStyle(fontSize: 20, color: Colors.white),),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //Text(user.email, style: TextStyle(color: Colors.white),),
                        SizedBox(height: 120,),
                      ],
                    ),
                ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
