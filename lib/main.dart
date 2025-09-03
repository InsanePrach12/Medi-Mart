import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/Auth/auth_page.dart';
import 'package:medi_mart/pages/Search/search.dart';
import 'package:medi_mart/pages/cart/cart_display.dart';
import 'package:medi_mart/pages/Mainpage/mainpage.dart';
import 'Services/firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        "/cart":(context) => const CartPage(),
        "/Homepage":(context) =>  mainpage(),
        "/Search":(context) => const SearchPage(),
      },
    );
  }
}

