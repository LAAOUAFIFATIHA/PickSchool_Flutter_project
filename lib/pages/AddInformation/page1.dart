import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/profileService.dart';


final _formKey = GlobalKey<FormState>();
class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}
class _Page1State extends State<Page1> {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final fieldController = TextEditingController();
  final levelController = TextEditingController();
  final noteController = TextEditingController();
  final ageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser! ;
  final ProfileService profileService = ProfileService();



  /// define what we need to load data
  List<DropdownMenuItem<String>> _dropdownItems = [];
  String? dropDownValue;
  ///  for levels
  List<DropdownMenuItem<String>> _dropdownLevel = [];
  String? dropdownLevel;

/// function to load data from json file ...
  Future<void> loadDropdownItemsFromJson() async {
    final String response = await rootBundle.loadString('json/listSchool.json');
    final  data = jsonDecode(response);

    setState(() {
      _dropdownItems = data["field"].map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['text']),
        );
      }).toList();


      // initial the dropdown value
      if (_dropdownItems.isNotEmpty){
        dropDownValue = _dropdownItems.first.value;
      }
    });

    setState(() {
      _dropdownLevel = data["levels"].map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['text']),
        );
      }).toList();

      // initial the dropdown value
      if (_dropdownLevel.isNotEmpty){
        dropdownLevel = _dropdownLevel.first.value;
      }
    });
  }

  // initialize the function
  @override
  void initState() {
    super.initState();
    loadDropdownItemsFromJson();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body:SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child:Form(
            key: _formKey,
            child: Column(
              children: [

                SizedBox(height: 80,) ,

                Text("Continue your information ", style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 22 ,
                ),),

                const SizedBox(height: 25,),

                /// name
                TextFormField(
                  controller:nameController ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ) ,
                      hintText: "name ",
                      fillColor: Colors.lightGreen ,
                    filled: true ,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    LengthLimitingTextInputFormatter(34), // Allows 34 characters maximum
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter text ";
                    }
                    if (value.length >= 35) {
                      return "Text number of characters not supported";
                    }
                    return null;
                  },
                ),
        
                const SizedBox(height: 18,),

                /// last name
                 TextFormField(
                              controller:lastnameController ,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
        
                                hintText: "last name ",
                                fillColor: Colors.lightGreen ,
                                filled: true ,
                              ),
                   inputFormatters: [
                     FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                     LengthLimitingTextInputFormatter(34), // Allows 34 characters maximum
                   ],
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return "Please enter text  ";
                     }
                     if (value.length >= 35) {
                       return "Text number of characters not supported";
                     }
                     return null;
                   },
                 ),

                const  SizedBox(height: 18,),

                /// note
                TextFormField(
                  controller:noteController ,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ) ,
                      hintText: "note",
                    fillColor: Colors.lightGreen ,
                    filled: true ,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    LengthLimitingTextInputFormatter(6), // Allows 34 characters maximum
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a number";
                    }
                    final number = int.tryParse(value);
                    if (number == null || number >= 20) {
                      return "Enter a note less than 20";
                    } if (number == null || number < 10  ) {
                      return "Please  enter a valid note (up to 10) ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18,),

                // for age
                TextFormField(
                  controller:ageController ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ) ,
                    hintText: "age",
                    fillColor: Colors.lightGreen ,
                    filled: true ,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    LengthLimitingTextInputFormatter(6), // Allows 34 characters maximum
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a number";
                    }
                    final number = int.tryParse(value);
                    if (number == null || number >= 20) {
                      return "Enter a note less than 20";
                    } if (number == null || number < 10  ) {
                      return "Please  enter a valid note (up to 10) ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18,),

                ///button to submit
                ElevatedButton(
                    onPressed: (){
            if (_formKey.currentState?.validate() ?? false){
              profileService.addFieldToDocument( "students",nameController.text , lastnameController.text  ,noteController.text, ageController.text  );}
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      shadowColor: Colors.white,
                      padding: const  EdgeInsets.symmetric(horizontal: 140  , vertical: 18 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text('Save' , style: TextStyle(color: Colors.black87 , fontWeight: FontWeight.bold ,),))
              ],
            ),
          )
        ),
      ),
    );
  }
}
