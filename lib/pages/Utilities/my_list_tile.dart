import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget{
  final String text;
  final IconData icon;
  final Function()? onTap;
  const MyListTile({super.key,required this.text,required this.icon,required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title:Text(text),
      onTap: onTap,
    );
  }
  
}