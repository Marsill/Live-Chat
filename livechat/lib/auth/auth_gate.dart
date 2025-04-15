import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livechat/loginOrSignup.dart';
import 'package:livechat/mandane/homepage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          //user logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          //user not logged in
          else{
            return const LoginOrSignup();
          }
        },
      ),
    );
  }
}