import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_project/pages/add_school.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_project/pages/auth_page.dart';
import 'package:real_project/pages/profile.dart';
import '../services/fire_store.dart';
import '../services/school.dart';
import '../services/student.dart';
import 'navbar.dart';


class home extends StatefulWidget {
home({super.key  });

@override
State<home> createState() => _homeState();}

class _homeState extends State<home> {
// information about user
final user = FirebaseAuth.instance.currentUser! ;
final FirestoreService firestoreService = FirestoreService();
final student Student = student();
final school School = school();
final textController = TextEditingController();
List<Map<String , dynamic >> Listy = [] ;
List <dynamic> listOfFieldsClassent = [];

List<dynamic> dataofStudent = [];
List <dynamic> listOfFieldsClassent1 = [];

// to wait for the load of data
int dataofStudentLengh = 0 ;
String StdNname = '';

var studentInSchoolsNumber =[] ;
var studentSchoolsNumber = "no schools";

  void getNumberofSchool() async {
    studentSchoolsNumber = await Student.getNumberOfSchools(user.email.toString());
  }

  getNumberofStudent() async {
    final data = await School.getNumberOfStudent( user.email.toString());
    setState(() {
      studentInSchoolsNumber = data ;
    });

  }

  /// the function of sorted items
  void getSortedMapsFromDocuments() async {

    final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email',);

    // Check if the document ID is null.
    final documentId = document?.id;
    if (documentId == null) {
      return;
    }
    await getNumberofStudent();
    /// Fetch the document snapshot.
    final docSnapshot = await FirebaseFirestore.instance.collection('students').doc(documentId).get();

    /// Return the 'school' field or an empty list if not present.
    dataofStudent = await docSnapshot.data()?['school'] ?? [] ;
    setState(() {
      dataofStudentLengh = dataofStudent.length ;
    });
    for (var item in dataofStudent) {
      int indextoremove = studentInSchoolsNumber.indexWhere((map) => map['name'] == item["name"]);
      var nOfSchool = '';
      for (var field in item['field']) {

        /// i make it to save the map of the specific  student
        List<Map<String, dynamic>> filteredMaps = [
          {
            'student': user.email.toString(),
            'note': field['note'],
            'field': field['field'] ,
          }
        ];

        // Iterate over the documents
        final collectionRef =
        FirebaseFirestore.instance.collection('students');
        Query query = collectionRef.where('school', isNotEqualTo: null);
        QuerySnapshot querySnapshot = await query.get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Get the array field
          List<dynamic> arrayField = doc['school'];
          if (arrayField.isNotEmpty) {
            // Check if any map in the array contains the specific value
            for (var map in arrayField) {
              for (var field2 in map['field']) {
                for (var MapOfSchool in arrayField) {
                  for (dynamic NStudent in studentInSchoolsNumber) {
                    dynamic NStudentKeys = NStudent.keys;
                    if (NStudentKeys.contains(MapOfSchool["name"])) {
                      setState(() {
                        nOfSchool = NStudent[MapOfSchool["name"]];
                      });
                    }
                  }
                }

                if (field2['field'] == field['field'] &&
                    map['name'] == item['name'] &&
                    map['univesity'] == item['univesity'] &&
                    map['city'] == item['city']) {
                  // Add the map to the filtered list
                  filteredMaps.add({
                    'student': doc['email'],
                    'note': field2['note'],
                    'field': field2['field'],
                  });
                }
              }
            }
          } else {
            print('Empty school in this doc');
          }


          try {
            filteredMaps.sort((a, b) {
              return (num.parse(b['note']))
                  .compareTo(num.parse(a['note']));
            });
            print('Sorted Maps: ${filteredMaps}');
          } catch (e) {
            print('Error during sorting: $e');
          }
        }
        for (int i = 0; i < filteredMaps.length; i++) {
          Map item = filteredMaps[i];
          if (item['student'] == user.email.toString()) {

            setState(() {
              if  (!listOfFieldsClassent.contains({'field': item['field'], 'note':item['note'], 'classement': i + 1,})){
              listOfFieldsClassent1.add({
                'field': item['field'],
                'note':item['note'],
                'classement': i + 1,
              });
              }
            });
            break; // Exit loop early if you only need the first match
          }
        }
      }

      listOfFieldsClassent.add({ 'name':item['name'] ,'numberOfStudent':  studentInSchoolsNumber[indextoremove]["NumberOfStudents"] ,'university':item['univesity'] , 'city':item['city'] , 'AllField':listOfFieldsClassent1});
      listOfFieldsClassent1 = [];
      nOfSchool = '' ;
    }
    setState(()  async {
      listOfFieldsClassent =  await listOfFieldsClassent ;
    });
  }


// to get the number of field in such school
  getfieldofschoolNumber(){

  }

// the function of fetch ....
Future<List<dynamic>> getArrayField(String school) async {
    final document = await firestoreService.getDocumentIdByIdentifier(school, 'schools', 'name');
    final documentId = document?.id;

    if (documentId == null) {
      print('Document not found???');
      return [];
    }
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('schools').doc(documentId).get();

    if (!docSnapshot.exists) {
      print('Document does not exist');
      return [];
    }
    List itemsArray = List.from(docSnapshot.get('student'));

    print('Retrieved items: $itemsArray');
    return itemsArray;
}


/// to ensure that the user sure for him choice of deleting field
void ensureDeleting ( index , e , schoolToDelete , lenght , MapOfSchools , university , city )  async{
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
        content: Text("You want to delete :   "+e["field"].toString()+"\n\n Are you sure ?"),
        actions: [

        ElevatedButton(
            onPressed: () async{
                if (lenght > 1 ){
                final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString() , 'students' , 'email' );
                final docIDSchool = document?.id;
                firestoreService.removeItemToNestedArray(docIDSchool ,e, schoolToDelete , 'students' , 'school'  , 'email' , 'name' ,university , city );
                print("student removed successfully ");

                //------------------------------ from schools ---------------------------------//

                final document1 = await firestoreService.getDocumentIdByIdentifier(schoolToDelete, 'schools' , 'name');
                final docIDStudent = document1?.id;

                firestoreService.removeItemToNestedArray(docIDStudent , e , user.email.toString() , 'schools' , 'student' ,  'name' , 'student email' , university , city );
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>home()));
                }else{
                  print('in else to remove this field ...........');


                //-------------------------- from students --------------------------------//

                final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email');
                final docIDSchool = document?.id;
                await firestoreService.removeItemFromArray(docIDSchool.toString(), MapOfSchools , index , 'students' , 'school');

                  //------------------------------ from schools ---------------------------------//

                  final document2 = await firestoreService.getDocumentIdByIdentifier( schoolToDelete, 'schools', 'name');
                  final docIDSchool2 = document2?.id;

                  // to load data from fire base
                  List<dynamic> itemsOfField = await getArrayField(schoolToDelete.toString());
                  int indextoremove = itemsOfField.indexWhere((map) => map['student email'] == user.email.toString());
                  firestoreService.removeItemFromArray(docIDSchool2.toString(), itemsOfField[indextoremove], indextoremove, 'schools', 'student');

                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>home()));
                }
            },
            child: Text("Yes")
        ),

            // button to cancel
            ElevatedButton(
                onPressed: (){
                    Navigator.pop(context);
                },
                child: Text("No")
            )
        ],
        ),
    );
}


/// function to make sure of delete
void ensureChoiceToDeleteSchool( index , MapOfSchools , schoolToRemove) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
        content: Text("You want to delete "+schoolToRemove.toString()+"\n\n Are you sure ?"),
        actions: [
        ElevatedButton(
            onPressed: () async{

            //-------------------------- from students -------------------------------------//

            final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email');
            final docIDSchool = document?.id;
            await firestoreService.removeItemFromArray(docIDSchool.toString(), MapOfSchools ,index , 'students' , 'school');

            //------------------------------ from schools ---------------------------------//

            final document2 = await firestoreService.getDocumentIdByIdentifier( schoolToRemove , 'schools', 'name');
            final docIDSchool2 = document2?.id;

            // to load data from fire base
            List<dynamic> itemsOfField = await getArrayField(schoolToRemove.toString());
            // print("the data is loaded from function"+itemsOfField.toString()+"length=== "+itemsOfField.length.toString());
            await firestoreService.removeItemFromArray(docIDSchool2.toString(), itemsOfField[index], index, 'schools', 'student');
            // print('From schools, it is good second time : ${itemsOfField[index]}');
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>home()));
            },
            child: Text("Yes")
        ) ,
        ElevatedButton(
            onPressed: (){
            Navigator.pop(context);
            },
            child: Text("No")
        )
        ],
        )
    );
}


/// to convert the list of fields to stream
Stream<List<dynamic>> get getFieldsOfSuchSchool {
  return Stream.value(listOfFieldsClassent);
}


/// to get the name of student
getStudentName() async {
    final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email',);
    final documentId = document?.id;
    if (documentId == null) {
      return;
    }
    final docSnapshot = await FirebaseFirestore.instance.collection('students').doc(documentId).get();
    final String data = docSnapshot.data()?['name'];
    if (data.isNotEmpty){
      print('the name gets great this is great ');
    setState(() {
      StdNname = data ;
    });}
    print(' the name is here ${data}');

  }


@override
void initState()   {
// TODO: implement initState
  super.initState();
  setState(() {
    getNumberofSchool();
    getSortedMapsFromDocuments();
    getStudentName();
  });
}

@override
Widget build(BuildContext context) {
  return Center(
    child: Scaffold(
      drawer: navbar(),
      backgroundColor: Colors.green[50],

    appBar: AppBar(
          title: const  Text('PickSchool' , style: TextStyle(color: Colors.black87 , fontWeight: FontWeight.bold , fontSize: 20),),
          centerTitle: true ,
          backgroundColor: Colors.green[300],
        // title: Text('Welcome'+user.email!),
        actions: [
        IconButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
        },
        icon: Icon(Icons.perm_contact_cal , color: Colors.black87,)),
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

        ],
    ),

    body: Column(
        children: [

        Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          child: StreamBuilder<List<dynamic>>(
          stream: getFieldsOfSuchSchool,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCube(color: Colors.grey ,
                size: 50.0,
                ),);
          } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          } if (dataofStudentLengh != listOfFieldsClassent.length  && dataofStudentLengh !=0){
              return const Center(
                  child: SpinKitFadingCube(
                    color: Colors.grey,
                    size: 50.0,
                  ));
            }
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items found'));
          } else {
          List<dynamic> _Schools = snapshot.data!;
          // print('the schools   ${_Schools}');
          
          // print('the schools and all the data here ${_Schools}');
          return ListView.builder(
          itemCount: _Schools.length,
          itemBuilder: (context, index) {
            return Column(
          children: [
            SizedBox(height: 10,) ,

            // for the first text
            if(index == 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,

                // to design the text hello name
                children: [
                  Text.rich(
                      TextSpan(
                        text: 'Hello ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: StdNname.toString(), // Student name in black
                            style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text: " you are registered in \n",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          TextSpan(
                            text: studentSchoolsNumber.toString(), // School number
                            style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text: studentSchoolsNumber == "1" ? " school" : " schools", // Conditional text based on the number of schools
                          ),

                        ],
                      )

                  )
                ],
              ),

          const SizedBox(height: 20 ,),
          GestureDetector(
          child: Card(
          color: Colors.white,
          child: ListTile(
            title: RichText(
              text: TextSpan(
                text: _Schools[index]['name'].toString() + " ", // School name
                style: TextStyle(color: Colors.black), // Normal text style
                children: <TextSpan>[
                  TextSpan(
                    text: _Schools[index]['numberOfStudent'].toString(), // Number of students
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold text style for number of students
                  ),
                ],
              ),
            ),
          leading: Text(_Schools[index]['university'].toString()+'\n'+_Schools[index]['city'].toString() , style: TextStyle(color: Colors.black87),),
          trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          
          // Delete school from student's schools and student from school's students
          IconButton(
            onPressed: () async {
                ensureChoiceToDeleteSchool(index , _Schools[index] , _Schools[index]["name"]);
            },
                icon: const Icon(Icons.delete ,color: Colors.black26),
                    ),
            ],
            ),
            ),
            ),
          ),
            for ( Map  item in _Schools[index]['AllField']  )
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// to add not or classement
            SizedBox(width: 5,),

            Card(
              color: Colors.green[200],
              child: Container(
                  color: Colors.grey[100], // Adjusted valid color
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(2),
                  child: RichText(
                  text: TextSpan(
                  children: [
                  TextSpan(
                      text:  item['field'].toString(),
                      style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      ),
                  ),
                  TextSpan(
                      text: item['classement'].toString(),

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22, // Larger size for the second part
                      color: Colors.green, // Different color for the second part
                      ),
                      ),
                      ],
                  ),
                  ),
              ),
            ),

            // Delete school from student's schools and student from school's students
            IconButton(
                onPressed: () async {
                    print('to delete ITEMS ');
                  List lenght = _Schools[index]['AllField'];

                  //-------------------------- from students -------------------------------------//
                  ensureDeleting( index , { 'field' :item['field'].toString() , 'note':item['note'].toString()}, _Schools[index]['name'].toString() ,lenght.length ,_Schools[index] , _Schools[index]['university'].toString() , _Schools[index]['city'].toString());

                },
                icon: const Icon(Icons.delete ,color: Colors.grey,size: 15,),
            ),
             ],
             ),
            ],
          );
          }
          );
          }
                 }
                ),
        ),
   ),

          // Container(
        //   child: ElevatedButton(
        //     onPressed: () async {
        //
        //       print("the results = "+studentSchoolsNumber);
        //
        //
        //     },
        //     child: Text("save"),
        //   ),
        // ),

        Container(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
            child: ElevatedButton(
            onPressed: (){
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSchool()),
                );
            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  shadowColor: Colors.white,
                  padding: const  EdgeInsets.symmetric(horizontal: 90  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
            child: Text("Add school" , style: TextStyle(
                color: Colors.black,
                letterSpacing:  3 ,
                fontSize: 20 ,
            ),)),
            ),
        ),
        ],
    ),
));
}
}
