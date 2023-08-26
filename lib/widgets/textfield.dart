import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  const MyTextField({Key? key, required this.obscuretext, this.onpressed, required this.controls, required this.maxLines, required this.Hinttext}) : super(key: key);

  final String Hinttext;
  final TextEditingController controls;
  final int maxLines;
  final bool obscuretext;
  final void onpressed;

  Widget build(BuildContext context) {
    return TextField(
      
      obscureText: obscuretext,
      maxLines: maxLines,
      controller: controls,
      decoration: InputDecoration(
        hintText:Hinttext ,
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), fillColor: Colors.grey),
      
    );
  }
}
