import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Auth/login.dart';
import 'package:medi_mart/pages/Auth/registerpage.dart';
class Loginorregister extends StatefulWidget{
  const Loginorregister({super.key});

  @override
  State<Loginorregister> createState() => _LoginorregisterState();
}

class _LoginorregisterState extends State<Loginorregister> {
  bool showLoginPage= true;
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage; 
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return login(onTap: togglePages,);
    }
    else{
      return Registerpage(onTap: togglePages,);
    }
  }
}