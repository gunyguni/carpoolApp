import 'package:flutter/material.dart';
import 'package:handongcarpool/service/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // CustomPaint(
            //   size: Size,
            //   painter: P,
            // ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 80.0),
                Column(
                  children: <Widget>[
                    Image.asset('assets/car1.png'),
                    SizedBox(height: 16.0),
                    Text(
                      '한동 카풀',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
                RaisedButton(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/google.jpg',
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 85),
                          child: Text(
                            'GOOGLE',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                  onPressed: () async {
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      print('Error signing in');
                    } else {
                      print('signed in');
                      print(result.uid);
                    }
                  },
                ),
                SizedBox(height: 12.0),
                RaisedButton(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.account_circle),
                      Container(
                          padding: EdgeInsets.only(left: 100),
                          child: Text(
                            'Guest',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnonymous();
                    if (result == null) {
                      print('Error signing in');
                    } else {
                      print('signed in');
                      print(result.uid);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
