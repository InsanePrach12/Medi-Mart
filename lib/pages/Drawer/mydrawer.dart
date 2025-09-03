import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Utilities/my_list_tile.dart';

class Mydrawer extends StatelessWidget{
  const Mydrawer({super.key});
  void signOut(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
    data: Theme.of(context).copyWith(
    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 0,
      color: Colors.transparent,
    ),
  ),
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                      
                margin: EdgeInsets.zero,
                child: 
                Image.asset('lib/images/Medi-mart.png',height: 100,),
                ),
                MyListTile(text: "HomePage", icon: Icons.home, onTap:(){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/Homepage");
                }),
                SizedBox(height: 10,),
                MyListTile(text: "Cart", icon: Icons.shopping_cart, onTap:(){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/cart");
                }),
                SizedBox(height: 10,),
                MyListTile(text: "Profile", icon:Icons.person, onTap:(){}),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: MyListTile(text: "LogOut", icon:Icons.logout, onTap: signOut),
            )
      
      
          ],
        ),
      ),
    );
  }
  

}