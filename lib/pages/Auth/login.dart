import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Utilities/my_button.dart';
import 'package:medi_mart/pages/Utilities/mytextfield.dart';
import 'package:medi_mart/pages/Utilities/square_tile.dart';
class login extends StatefulWidget{
  final Function()? onTap;

  const login({super.key,required this.onTap});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final emailController=TextEditingController();

  final passwordController=TextEditingController();
  void wrongemail(String message){
    showDialog(context: context, 
    builder:(context){
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(child: Text(message,

        ))
        
    );
  });
  }


  void SignUserIn() async{
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text, 
    password: passwordController.text);
    Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      //print(e.code);
      wrongemail(e.code);
      
    }
    
    
  } 



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                
                Image.asset(
                  "lib/images/Medi-mart.png",
                  height: 100,
                ),
                //SizedBox(height: 20,),
                Text("Welcome to Medi-Mart",
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),
                SizedBox(height: 20,),
                mytextfield(
                  controller: emailController,
                  hintText: "Type your Email",
                  obscuretext: false,
                ),
                SizedBox(height: 20,),
                mytextfield(
                  controller: passwordController,
                  hintText: "Type your Password",
                  obscuretext: true,
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot Password?",
                      style: TextStyle(
                        color: Colors.grey,
                      ),),
                    ],
                  ),
                ),
                MyButton(onTap: SignUserIn,
                text: "Sign in",),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Text("Or Continue With"),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SquareTile(imagepath: 'lib/images/google.png')
                ],
                ),
                SizedBox(height: 20,),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New here?"),
                  SizedBox(width: 4,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Create an account',
                      style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),),
                    ),
                  )
                ],
                )
              ]
            ),
          ),
        ),
      )
    );
  }
}