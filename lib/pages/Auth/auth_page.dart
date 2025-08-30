import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Auth/loginOrRegister.dart';
import 'package:medi_mart/pages/Mainpage/mainpage.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<User?>(
       stream: FirebaseAuth.instance.authStateChanges(),
       builder:(context,snapshot){
        if(snapshot.hasData){
          return mainpage();
        }
        else{
          return Loginorregister();
        }
       }
       )
    );
  }
}