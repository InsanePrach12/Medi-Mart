import 'package:flutter/material.dart';
class mytextfield extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscuretext;
  const mytextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuretext,
    });
  @override
  Widget build(BuildContext context){
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: controller,
            obscureText:obscuretext,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
                  ),
                ),
              );
    
  }
}