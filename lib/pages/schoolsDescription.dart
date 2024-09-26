import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_project/pages/home.dart';
import '../components/text_field.dart';
import '../services/fire_store.dart';

class schoolDesc extends StatefulWidget {
  const schoolDesc({super.key});

  @override
  State<schoolDesc> createState() => _schoolDescState();
}

class _schoolDescState extends State<schoolDesc> {

  // define the list of school to load it from JSON file
  List _Schools = [];

  // define the function that we will need to provide schools from Json file

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('schools_1.json');
    final data = await jsonDecode(response);
    setState(() {
      if (data["schools"] is List) {
        _Schools = data["schools"].map((item) {
          item['isExpanded'] = false; // Add isExpanded flag to each item
          return item;
        }).toList();
      } else {
        print('Error: "schools" is not a list.');
      }
    });
  }

  // to know if the liste is expended or not
  void toggleExpansion(int index) {
    setState(() {
      _Schools[index]['isExpanded'] = !_Schools[index]['isExpanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Schools.isNotEmpty
                  ? Container(
                height: 300, // Set a height for the ListView
                child: ListView.builder(
                  itemCount: _Schools.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleExpansion(index);
                          },
                          child: Card(
                            key: ValueKey(_Schools[index]["id"]),
                            margin: const EdgeInsets.all(10),
                            color: Colors.amber.shade100,
                            child: ListTile(
                              leading: Text(_Schools[index]["id"].toString()),
                              title: Text(_Schools[index]["name"]),
                              subtitle: Text(_Schools[index]["description"]),
                            ),
                          ),
                        ),

                        if (_Schools[index]['isExpanded'] && _Schools[index]["field"] is List)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: _Schools[index]["field"].map<Widget>((field) {
                                return Card(
                                    key: ValueKey(field),
                                    margin: const EdgeInsets.all(8),
                                    color: Colors.grey,
                                    child: ListTile(
                                      leading: Text(field[1]),
                                      title: Text(field[0]),
                                    ),
                                  );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              )
                  : ElevatedButton(
                onPressed: () async {
                  await readJson();
                },
                child: const Text('Show Schools '),
              ),
            ],
          )

      ),
    ) ;
  }
}
