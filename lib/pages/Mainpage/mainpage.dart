import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/User/user.dart';
import 'package:medi_mart/pages/Mainpage/list.dart';
import 'package:medi_mart/pages/Drawer/mydrawer.dart';

class mainpage extends StatefulWidget{

  const mainpage({super.key});

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  final user= FirebaseAuth.instance.currentUser!;
  final Users users=Users.fromAuth();


 
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text("Medi-Mart",
        style: TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade300
        ),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, "/cart");
          }, icon: Icon(Icons.shopping_cart,
          color: Colors.black54,
          size: 30,))
        ],
      ),
      
      drawer: Drawer(
        child: Mydrawer(),
      ),
      body: GestureDetector(
         onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child:ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 50,
                  child: GestureDetector(
                    onTap: (){
                          Navigator.pushNamed(context, "/Search");
                        },
                    child: AbsorbPointer(
                      child: CupertinoSearchTextField(
                        placeholder: 'Search for products',
                        prefixIcon: Icon(Icons.search,color: Colors.grey,),
                        suffixIcon: Icon(Icons.clear,color: Colors.grey,),
                        backgroundColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              //Search(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue.shade200, 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                        stream: Users.fromAuth().getUserInfo(),
                        builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                              // snapshot.data is a DocumentSnapshot
                          var userData = snapshot.data!.data() as Map<String, dynamic>;
                          if(userData.isEmpty){
                            return Text("No Name",);
                            }                    
                          return Text("Hello, ${userData['FullName']}",
                          style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                          ), 
                          );
                        },
                          ),
                      Text("Let's get your medicine",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),),
                        
                      ],
                    ),
                  ),
                ),
              ),
        CategoryList(),
            ],
          )
        ),
      )
    );
  }
}