import 'package:flutter/material.dart';
import 'package:livechat/auth/login.dart';
import 'package:livechat/auth/signup.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context){
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    } else{
      return SignupPage(onTap: togglePages); 
    }
  }
  
}