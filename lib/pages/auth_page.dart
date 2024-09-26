import 'package:real_project/pages/home.dart';
import 'package:real_project/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class auth_page extends StatelessWidget {
  const auth_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context , snapshot){
      if ( snapshot.hasData) {
        return home();
      }
      else{
        return login_page() ;
      }
       }
     )
    );
  }
}
