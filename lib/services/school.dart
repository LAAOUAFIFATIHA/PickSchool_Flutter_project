import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_project/services/student.dart';
import 'fire_store.dart';


class school extends FirestoreService  {
  final student Student = student();

  getNumberOfStudent( student ) async {
    print('hello from getNumberOfStudent ');
    final listySchool = await Student.getSchoolsOfStudent(student);
    print('hello from getNumberOfStudent${listySchool}');

    List< dynamic> listofSchools = [];
    if (listySchool.isNotEmpty) {
      for (var school in listySchool) {
        final document = await getDocumentIdByIdentifier(
            school, 'schools', 'name');
        final studentID = document?.id;

        final docSnapshot = await FirebaseFirestore.instance.collection(
            'schools').doc(studentID).get();

        /// Return the 'school' field or an empty list if not present.
        var dataofStudent = await docSnapshot.data();
        List<dynamic>? studentData = dataofStudent?["student"];

        var numberOfSchools = studentData?.length;
        listofSchools.add({ "name":school , "NumberOfStudents": numberOfSchools.toString()});
      }
      print('ddddddddddddddddddddddddddddd ${listySchool}');
      return listofSchools;

}


    // getfieldofschoolNumber0( student ) async {
    //
    //   print('hello from getNumberOfStudent ');
    //   final listySchool = await  Student.getSchoolsOfStudent(student) ;
    //   print('hello from getNumberOfStudent${listySchool}');
    //
    // }


  }
}