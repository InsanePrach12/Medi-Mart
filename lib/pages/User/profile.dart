import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/User/user.dart';
import 'package:medi_mart/pages/Utilities/my_list_tile.dart';

class Profile extends StatelessWidget{
 
  const Profile({super.key});
    void signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
      context, '/Auth');
  }

  @override
  Widget build(BuildContext context){
    final Users user=Users.fromAuth();
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
    child: StreamBuilder(stream: user.getUserInfo(),
     builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting){
        return CircularProgressIndicator();
      }
      var userData = snapshot.data!.data() as Map<String, dynamic>;
      if(userData.isEmpty){
        return Text("No user data");
      }
      
      return Center(
        child: SizedBox(
              height: 400,
              width: 400,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 40,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)),
                  color: Colors.white,
                  child:Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        Center(
                          child:Icon( Icons.person,
                          size: 100,
                          color: Colors.blue.shade300,),
                        ),
                        Center(child: Text(userData['FullName'] ?? 'No Name',
                          style:TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        )),
                        Center(child: Text(userData['email'] ?? 'No Email',
                        style: TextStyle(fontSize: 15),)),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.home),
                          title: Text(userData['Address'] ?? 'No address'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('${userData['Phone'] ?? 'No phone'}'),
                        ),
                        MyListTile(text: "LogOut", icon:Icons.logout, onTap:()=>signOut(context)),
                      ],
                    ),
                  )
                ),
              ),
            )
      
      );
     }
     ),
    )
    );
  }
}
