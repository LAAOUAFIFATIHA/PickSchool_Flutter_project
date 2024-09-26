import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_project/pages/AddInformation/page1.dart';
import 'package:real_project/pages/AddInformation/page2.dart';
import 'package:real_project/pages/AddInformation/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../profile.dart';

class ContinueInf extends StatefulWidget {
  const ContinueInf({super.key});

  @override
  State<ContinueInf> createState() => _ContinueInfState();
}

class _ContinueInfState extends State<ContinueInf> {
  /// to control the pages
  final _Controller = PageController();
  /// to know if it is the last page or not
  bool isLastPage =false ;
  bool isFistPage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///PAGE VIEW
         PageView(
           controller: _Controller,
          onPageChanged: (index){
             setState(() {
               isLastPage = (index==2);
               isFistPage = (index ==0 );
             });
          },
          children: [
            Page1(),
            Page2(),
            Page3()
          ],
        ),

          Container(
            alignment: Alignment(0,0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// previous
                  isFistPage?Text("")
                  :GestureDetector(
                      onTap: (){
                        _Controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                      child: Text("Previous" , style: TextStyle( fontWeight: FontWeight.bold),)),

                  /// indicators
                  SmoothPageIndicator(controller: _Controller, count: 3),

                  /// next or done
                  isLastPage?
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>Profile()));
                      },
                      child: Text("Done" , style: TextStyle( fontWeight: FontWeight.bold),))

                      : GestureDetector(
                      onTap: (){
                        _Controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                      child: const Text("Next" , style: TextStyle( fontWeight: FontWeight.bold),)),
                ],
              ))
        ],
      ),
    );
  }
}
