import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/school.dart';
import 'bar.dart';
import 'barData.dart';

class MyGraph extends StatefulWidget {
  // constructor
  MyGraph({
    super.key,
  });

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  late Bardata bardata; // Declare Bardata instance
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Load data asynchronously
    _loadData();
  }

  // Function to load data
  void _loadData() async {
    bardata = Bardata(
      one: 0,
      tow: 30,
      three: 3,
      four: 4,
      five: 80,
      six: 6,
      seven: 100,
    );
    await bardata.InitializeBarData(); // Initialize the data
    setState(() {
      isLoading = false;  // Once the data is loaded, set isLoading to false
    });
  }

  @override
  Widget build(BuildContext context) {

    // const Text(
    //   'Data List:',
    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    // );
    // const SizedBox(height: 10);
    // Expanded(
    //   child: ListView.builder(
    //     itemCount: bardata.barInstance.length, // Number of items
    //     itemBuilder: (context, index) {
    //       final bar = bardata.barInstance[index];
    //       return ListTile(
    //         title: Text('Label: ${bar.x}'),
    //         subtitle: Text('Value: ${bar.y.toStringAsFixed(2)}'),
    //       );
    //     },
    //   ),
    // );

    if (isLoading) {
      // Show a loading indicator while the data is being loaded
      return Center(child: CircularProgressIndicator());
    } else {
      // Data is loaded, now show the list and the chart
      return Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better UI
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the list of data
            // Add some spacing

            const SizedBox(height: 20), // Add spacing between the list and chart
            // Display the chart
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  minY: 0,
                  barGroups: bardata.getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

}
