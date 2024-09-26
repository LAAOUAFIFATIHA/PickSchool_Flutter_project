import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Column(
          children: [

            const SizedBox(height: 30,),

            const Center(
                child: Text("Successful",style: TextStyle(
                  letterSpacing: 8 ,
                  fontSize: 22 ,
                  fontWeight: FontWeight.bold
                ),)),


                Expanded(
                    child: Image.asset(
                      'assets/image/flower.png' ,
                      color: Colors.green, // Apply the background color
                      colorBlendMode: BlendMode.multiply, // Blend mode that multiplies the color
                      fit: BoxFit.cover,), ),

          ],
        ),
      ),
    );
  }
}
