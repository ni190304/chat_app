import 'dart:math';

import 'package:chat_app/main.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleClick() {
    signInWithGoogle().then((user) {
      log('\nUser: ${user.user}' as num);
      log('\nUserAddInfo: ${user.additionalUserInfo}' as num);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home_Screen()));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Buzz Chat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * 0.15,
              right: _isAnimate ? mq.width * 0.25 : -mq.width * 0.5,
              width: mq.width * 0.5,
              duration: const Duration(milliseconds: 1000),
              child: Image.asset('images/chat.png')),
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.05,
              width: mq.width * 0.9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _handleGoogleClick();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      backgroundColor: Colors.lightGreen,
                      shape: const StadiumBorder(),
                      elevation: 1),
                  icon: Image.asset('images/google.png'),
                  label: RichText(
                    text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(text: 'Sign in with '),
                          TextSpan(
                              text: 'Google',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  ))),
        ],
      ),
    );
  }
}
