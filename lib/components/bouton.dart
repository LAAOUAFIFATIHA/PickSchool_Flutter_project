import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class my_bouton extends StatelessWidget {
  final Function() ? onTap ;
  my_bouton({
     super.key,
      required this.onTap ,
   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        padding:  const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.black ,
            borderRadius: BorderRadius.circular(8),

        ),
        child: Center(
          child: Text('sign in ' ,
          style: TextStyle(
            color: Colors.white ,
            fontWeight: FontWeight.bold ,
            fontSize: 16 ,
          ),),
        ),
      ),
    );
  }
}
