import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'function.dart';

class ApiPage extends StatefulWidget {
   ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  String output = '';
  String url = '';
  var data ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Row(

            children: [

              Text("HELLO "+output) ,
              SizedBox(height: 10,),
              Row(
                children: [

                  TextButton(
                      onPressed: () async {
                        data = await fetchdata(1 ,0 , 0);
                        print("the data here ${data}");
                        setState(() {
                          output ="${data["message"]} ${data["age"]} ${data["res"]}";
                        });
                      },
                      child: Text(
                        'Click',
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
