import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final String uid;
  final CollectionReference usersCollection;
   Users(this.uid) : usersCollection = FirebaseFirestore.instance.collection('Usersdetails');
   factory Users.fromAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');
    return Users(user.uid);
   }
  Future adduser(Map<String,dynamic> userinfo) async {
    // Add user to database
    await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      ...userinfo,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }
Stream<DocumentSnapshot> getUserInfo() {
    return usersCollection.doc(uid).snapshots();
  }

}
