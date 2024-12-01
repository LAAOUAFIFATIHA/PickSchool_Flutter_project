import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/school.dart';
import 'bar.dart';

class Bardata {
  late final double one;
  late final double tow ;
  late final double three;
  late final double four;
  late final double five ;
  late final double six;
  late final double seven;



  // instance of school class
  final school School = school();
  List<dynamic> studentData = [];
  int nom = 0 ;

  // get data from the schools table
  get user => FirebaseAuth.instance.currentUser!;

  //the function that will get the data
  getdata() async {
    print('the first appearance ');
    try {
      studentData = await School.getNumberOfStudent(user.email.toString());
      print("the data is :"+studentData.toString());
    }catch(e){
      print("the error is in the loading of data :"+e.toString());
    }
    nom = studentData.length;
  }

  // the constructor
Bardata ({required this.one ,
          required this.tow ,
          required this.three ,
          required this.four ,
          required this.five ,
          required this.six ,
          required this.seven }) ;

// take an instance from the bar class
  List<Bar> barInstance = [];
  // initialize the Bardata
  Future InitializeBarData() async{
    try {
      studentData = await School.getNumberOfStudent(user.email.toString());
      print("the data is :"+studentData.toString()+"jfjjfjfjj"+studentData.length.toString());
    }catch(e){
      print("the error is in the loading of data :"+e.toString());
    }
  print('fin of loading of data '+studentData[0]["name"].substring(7, 14));
    barInstance = [
      // data that will appear on tha graph
      for (int i= 0 ; i < studentData.length ; i++)
        Bar( x:i , y: double.parse(studentData[i]["NumberOfStudents"].toString())),
        // Bar( x: 1 , y: 1),
        // Bar( x: 2 , y: 2),
    ];
    print('fin of initializing  ');
  }


  // Convert Bar instances to BarChartGroupData
  List<BarChartGroupData> getBarGroups() {
    return barInstance.map((bar) {
      return BarChartGroupData(
        x: bar.x,
        barRods: [BarChartRodData(toY: bar.y)],
      );
    }).toList();
  }
}