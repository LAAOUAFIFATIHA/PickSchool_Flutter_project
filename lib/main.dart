import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:real_project/pages/analyse/analyse.dart';
import 'package:real_project/pages/api.dart';
import 'package:real_project/pages/welcomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ApiPage(),
      home: splash_screen(),
      //home: analyse(),
    );
  }
}
