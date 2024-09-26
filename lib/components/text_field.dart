import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomTextField extends StatelessWidget {
  final controller ;
  final String hintText ;
  final bool obscureText ;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: controller,
         obscureText: obscureText ,
         decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          ) ,
          fillColor: Colors.white,
          filled: true ,
           hintText:   hintText,


        ),
      ),
    );
  }
}
