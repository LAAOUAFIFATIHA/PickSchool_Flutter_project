import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/fire_store.dart';

final _FormKey = GlobalKey<FormState>();

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final NotsNAController = TextEditingController();
  final NotsREController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  File? returnedImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Colors.yellowAccent[400],
        child: Form(
          key: _FormKey,
          child: Column(children: [
            SizedBox(height: 80,) ,
              /// note of national
          TextFormField(
            controller:NotsNAController ,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: " note of national  "
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return " Please enter a number";
              }
              final number = int.tryParse(value);
              if (number == null || number >= 20) {
                return "Enter a number less than 20";
              }if (number == 0   ) {
                return "Please  enter a valid note (up to 0) ";}
              return null;
            },
          ),

            SizedBox(height: 40,) ,

            /// note of regional
            TextFormField(
              controller: NotsREController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: " note  of  regional ",
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a number";
                }
                final number = int.tryParse(value);
                if (number == null || number >= 20) {
                  return "Enter a number less than 20";
                }if (number == 0   ) {
                  return "Please  enter a valid note (up to 0) ";
                }
                return null;
              },
            ),

            SizedBox(height: 40,) ,
            ///add text to but control

            SizedBox(height: 40,) ,

            /// button
            ElevatedButton(
                onPressed: (){
                  if (_FormKey.currentState?.validate() ?? false){
                    // add here function to add what you want to the collection you want
                    //
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shadowColor: Colors.white,
                  padding: const  EdgeInsets.symmetric(horizontal: 140  , vertical: 18 ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text("Save"))
          ]),
        ),
      ),
    );
  }
}
