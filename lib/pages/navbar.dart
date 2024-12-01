import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:real_project/pages/profile.dart';
// import 'package:real_project/pages/schoolsDescription.dart';
import 'analyse/analyse.dart';
import 'analyse/myGraph.dart';
import 'api.dart';
import 'auth_page.dart';

class navbar extends StatefulWidget {
  navbar({super.key});



  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return   Column(
      children: [
        Expanded(
          child: Drawer(
            child: ListView(
              children: [

                // the profile
                UserAccountsDrawerHeader(
                    accountName: const  Text("student"),
                    accountEmail: Text(user.email.toString()),
                    currentAccountPicture:IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
                      // icon: Icon(Icons.perm_contact_cal , color: Colors.black87,)
                      icon:  CircleAvatar(
                        child:  Image.asset('assets/img.png'),
                      ),
                    ),
                ),

               const  SizedBox(height: 12,),

                // logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut() ;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => auth_page()),
                        );
                      },
                      icon:  Icon(Icons.logout) ,
                      color: Colors.black87,
                    ),
                    Text('logout '),
                  ],
                ),

                const  SizedBox(height: 12,),

                // show schools
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut() ;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApiPage()),
                        );
                      },
                      icon:  Icon(Icons.school_outlined , size: 30,) ,
                      color: Colors.black87,
                    ),
                    const Text('show schools'),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(
                                                 builder: (context) => analyse()));

                        } ,
                        icon: Icon(Icons.analytics),
                        color: Colors.black87
                    ),
                    const Text("Analyse"),

                ],)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
