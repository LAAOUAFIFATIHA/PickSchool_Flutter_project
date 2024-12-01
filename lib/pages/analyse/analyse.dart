import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'myGraph.dart';



class analyse extends StatefulWidget {
  const analyse({super.key});

  @override
  State<analyse> createState() => _analyseState();
}

class _analyseState extends State<analyse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse'),
        backgroundColor: Colors.green[400],
      ),
      body: Center(
          child: SizedBox(
            height: 200,
              child: MyGraph())),
    );
  }
}
