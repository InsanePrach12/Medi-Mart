import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Utilities/my_button.dart';
import 'package:medi_mart/pages/Utilities/mytextfield.dart';
import 'package:medi_mart/pages/Utilities/square_tile.dart';
class Registerpage extends StatefulWidget{
  final Function()? onTap;

  const Registerpage({super.key,required this.onTap});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  void showerrorMessage(String message){
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


  void SignUserUp() async{
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    );
    try {
      if(passwordController.text==confirmPasswordController.text){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text, 
    password: passwordController.text);
        Navigator.pop(context);
      }
      else{
        Navigator.pop(context);
        showerrorMessage("Password doesn't match");
        return;
      }

    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      //print(e.code);
      showerrorMessage(e.code);
      
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
                  hintText: "Email",
                  obscuretext: false,
                ),
                SizedBox(height: 20,),
                mytextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscuretext: true,
                ),
                SizedBox(height: 20,),
                mytextfield(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscuretext: true,
                ),
                SizedBox(height: 30,),
                MyButton(onTap: SignUserUp,
                text: "Register",),
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
                  Text("Already a user"),
                  SizedBox(width: 4,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Login',
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