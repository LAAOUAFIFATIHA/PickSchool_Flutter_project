import 'package:cloud_firestore/cloud_firestore.dart';
import 'fire_store.dart';

class student extends FirestoreService  {

  Future<List> getSchoolsOfStudent( student ) async {
    final document = await getDocumentIdByIdentifier(student , 'students' , 'email' );
    final studentID = document?.id;

    final docSnapshot = await FirebaseFirestore.instance.collection('students').doc(studentID).get();

    /// Return the 'school' field or an empty list if not present.
    var dataofStudent = await docSnapshot.data();
    List<dynamic>? studentData = dataofStudent?["school"] ;
    List listy =[];
    for (var  map in  studentData!){
      listy.add(map["name"]  );
    }
    print("the student rrrrrrrrrrrrrrrrrr${listy}");
    return listy ;
  }


  Future<String> getNumberOfSchools( student ) async {

    final document = await getDocumentIdByIdentifier(student , 'students' , 'email' );
    final studentID = document?.id;

    final docSnapshot = await FirebaseFirestore.instance.collection('students').doc(studentID).get();

    print(docSnapshot);

    /// Return the 'school' field or an empty list if not present.
    var dataofStudent = await docSnapshot.data();
    List<dynamic>? studentData = dataofStudent?["school"] ;
    List listy =[];
    for (var  map in  studentData!){
      listy.add(map["name"]);
    }
    print("the student rrrrrrrrrrrrrrrrrr${listy}");

    var numberOfSchools = studentData?.length;
    return numberOfSchools.toString() ;

  }


}