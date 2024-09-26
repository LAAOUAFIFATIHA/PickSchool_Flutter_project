import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:real_project/pages/home.dart';
import 'package:real_project/services/fire_store.dart';

class AddSchool extends StatefulWidget {
  const AddSchool({super.key});

  @override
  State<AddSchool> createState() => _AddSchoolState();
}
class _AddSchoolState extends State<AddSchool> {
  String selectedUniversity = "";
  List<String> universityItems = []; // Example items
  List<DropdownMenuItem<String>> universityItemsD = [];
  final firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;
  final fieldOfBacController = TextEditingController();
  final NnoteController = TextEditingController();
  final RnoteController = TextEditingController();
  final noteOfBacController = TextEditingController();

  ///
  String noteN = '';
  String noteR = '';

  ///
  String NMark = '';
  String RMark = '';
  String fieldSelect = '';

  ///
  String indexOfStudent = "" ;

  /// load  cities
  String selectedCity = "";
  List<String> CityItems = []; // Example items
  List<DropdownMenuItem<String>> CityItemsD = [];

  /// load  school
  String selectedSchool = "";
  List<String> SchoolItems = []; // Example items
  List<String> listOfFieldInEachSchool = [];
  List<String> ListtoGetFromitIndexOfSchool = [];
  List<DropdownMenuItem<String>> SchhoolItemsD = [];

  /// load  field
  String selectedField = "";
  List<String> FieldItems = [];
  List<String> listOfItems = [] ;
  List<DropdownMenuItem<String>> FieldItemsD = [];

  /// load  field
  String selectedweight_factorItems = "";
  List<String> weight_factorItems = [];
  List<String> listBacfieldInEveryField = [];
  List<DropdownMenuItem<String>> weight_factorItemsD = [];

  /// load  field
  Map<String, dynamic> weight_factorItemsValues = {};

  List<String> weight_factorItemsValues0 = [];

  /// Load data from JSON file
  void loadJsonFile(bool city, bool school, bool field , bool withField) async {
    final String response = await rootBundle.loadString("assets/json/QadiAyyad.json");
    final data = jsonDecode(response);


    /// Since the 'universities' key is an array, we access it as a list
    final List universities = data['univesities'];


    for (var university in universities) {
      university.forEach((universityName, details) {
        // print('University: $university');
        setState(() {
          if (!universityItems.contains(universityName)) {
            universityItems.add(universityName);
          }
        });
      });
    }
    if (city) {
      dynamic pickedUniversity = data['univesities'][0][selectedUniversity][0] ;
      for (var cityName in pickedUniversity['Cities']) {
        cityName.forEach((cityName, cityDetails) {
          // print('  City: $cityName');
          if (!CityItems.contains(cityName)) {
            CityItems.add(cityName);
          }
          if (school) {
            int index = CityItems.indexWhere((city) => city.contains(selectedCity));
            dynamic setOfSchools = data['univesities'][0][selectedUniversity][0]['Cities'][index][selectedCity][0]['Schools'] ;

            for (var school in setOfSchools) {
              school.forEach((schoolName, schoolDetails) {
                if (!SchoolItems.contains(schoolName) ) {

                /// goal : get all the field of each school
                  for (var mapOfSchools in  school[schoolName][0]['fields']){

                    /// list to get all the schools to get from it the index .
                    ListtoGetFromitIndexOfSchool = [];
                    for ( var mapOfSchoolforIndex in setOfSchools){
                        for ( var schoolForIndex  in mapOfSchoolforIndex.keys) {
                          if (!ListtoGetFromitIndexOfSchool.contains(schoolForIndex)){
                            ListtoGetFromitIndexOfSchool.add(schoolForIndex);
                          }
                        }
                    }

                    /// get the field that are in  every field
                    for (var field in mapOfSchools['weight_factor'].keys){
                      if (!listBacfieldInEveryField.contains(field)){
                      listBacfieldInEveryField.add(field);
                      }
                    }
                    for (var U in listBacfieldInEveryField){
                    if (!listOfFieldInEachSchool.contains(U)){
                      listOfFieldInEachSchool.add(U);
                    }
                  }
                    listBacfieldInEveryField = [];
                  }


                /// this for the field of each school .
                try{
                  for (var i in listOfFieldInEachSchool){
                    print('"""""""""""""""""""${fieldSelect}"""""""""""""""""""""""""""${listOfFieldInEachSchool}');
                    if (i == fieldSelect){
                    SchoolItems.add(schoolName);
                  }else if (fieldSelect == ""){
                      if (!SchoolItems.contains(schoolName)){
                    SchoolItems.add(schoolName);}
                  }
                  }}catch(e){
                    print('the error is ${e}');
                }
                  /// clear the list to an other school
                  listOfFieldInEachSchool = [];
                }

                if (field) {
                  listOfItems = [];
                  int indexOfSchool = ListtoGetFromitIndexOfSchool.indexWhere((school) => school.contains(selectedSchool));

                  dynamic pickedschoolPickField = data['univesities'][0][selectedUniversity][0]['Cities'][index][selectedCity][0]['Schools'][indexOfSchool][selectedSchool][0];

                  for (var field in pickedschoolPickField['fields']) {
                    if (!FieldItems.contains(field['name'])) {

                      Map<String , dynamic> mapedItem = {};
                       mapedItem = field['weight_factor'];
                      listOfItems = [];

                      for (var bacfield in  mapedItem.keys ){
                        if (!listOfItems.contains(bacfield) ){
                          listOfItems.add(bacfield);
                        }
                      }
                      print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv${mapedItem.keys} VVVVV ${field['name']}');


                      // the first time when the user will register to a school
                      if ( fieldSelect == ''){
                          FieldItems.add(field['name']) ;
                      }

                      for (var r in listOfItems){
                        if (r == fieldSelect){
                      FieldItems.add(field['name']);
                      }}
                    }
                    if (withField) {
                      for (var e in field['weight_factor'].keys) {
                        if (!weight_factorItems.contains(e.toString())) {
                          if (field['name'] == selectedField && schoolName == selectedSchool ){
                            weight_factorItems.add(e.toString());
                          }
                        }

                        for (var WF in weight_factorItems) {
                          if (!weight_factorItemsValues.keys.contains(WF.toString()) && field['name'] == selectedField) {
                            weight_factorItemsValues.addAll({
                              WF: field['weight_factor'][WF]
                            });

                          }}
                      }
                    }
                  }
                }
                listOfItems = [];
              });
            }
            listOfFieldInEachSchool = [];
          }
        });
      }
    }
    intoDropdownUNI();
  }

  void  intoDropdownUNI() {
     CityItemsD = CityItems.map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
    setState(() {
      if (CityItems.isNotEmpty && selectedCity.isEmpty) {
          selectedCity = CityItems.first;
      }});
    universityItemsD = universityItems.map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
    setState(() {
      if (universityItems.isNotEmpty && selectedUniversity.isEmpty) {
        selectedUniversity = universityItems.first;
      }
    });

    /// load schools
    print('inside school  ');
    SchhoolItemsD = SchoolItems.map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
    setState(() {
      if (SchoolItems.isNotEmpty && selectedSchool.isEmpty) {
        selectedSchool = SchoolItems.first;
      }
    });
    FieldItemsD = FieldItems.map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
    setState(() {
      if (FieldItems.isNotEmpty && selectedField.isEmpty) {
        selectedField = FieldItems.first;
      }
    });

     weight_factorItemsD = weight_factorItems.map<DropdownMenuItem<String>>((String item) {
       return DropdownMenuItem<String>(
         value: item,
         child: Text(item),
       );
     }).toList() ;
    setState(() {
      if (weight_factorItems.isNotEmpty && (selectedweight_factorItems == null || !weight_factorItems.contains(selectedweight_factorItems))) {
        selectedweight_factorItems = weight_factorItems.first;
      }
    });

  }

  /// to get marks of national  and  regional
  void getMarksFromDoc() async {
    print (' the function work great §§§§§§ §§§§§ §§§§§ §§§§§ ');

    /// Reference to the Firestore collection
    final collectionRef = FirebaseFirestore.instance.collection('students');

    /// Query to get documents that contain the array field
    Query query = collectionRef.where('email', isEqualTo: user.email.toString());

    /// to get the docs
    QuerySnapshot querysnapshot =  await query.get();

    for (QueryDocumentSnapshot doc in querysnapshot.docs){
      setState(() {
        NMark  = doc['Nnote'];
        RMark  = doc['Rnote'];
        fieldSelect = doc['field'];
      });
    }

  }

  @override
  void initState() {
    super.initState();
    getMarksFromDoc();
    intoDropdownUNI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title:const Text('PickSchool' , style: TextStyle(color: Colors.black87 , fontWeight: FontWeight.bold , fontSize: 20),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>home()));
          }, icon: Icon(Icons.home , color: Colors.black,))
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[250],
          child: Column(
            children: [
              Text(indexOfStudent.toString()),
        
              (NMark == '')?
                  Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: NnoteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.green, // Border color when focused
                          width: 2.0, // Border width when focused
                        ),
                      ),
                    hintText: " national "
                  ),
                ),
              )
                  :SizedBox(),
        
              (NMark == '')?
                  Container(
                padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                child: TextFormField(
                  controller: RnoteController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.green, // Border color when focused
                          width: 2.0, // Border width when focused
                        ),
                      ),
                      hintText: " regional "
                  ),
                ),
              )
              :SizedBox(),
        
              (NMark == '')?
                  Container(
                padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                child: TextFormField(
                  controller: noteOfBacController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.green, // Border color when focused
                          width: 2.0, // Border width when focused
                        ),
                      ),
                      hintText: " bac Mark "
                  ),
                ),
              ):SizedBox(),
        
        
              SizedBox(height: 20,),
        
              // the university
              Container(
                padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                child: GestureDetector(
                  onTap: () {
                    loadJsonFile(false, false, false , false);
                  },
                  child: universityItems.isEmpty
                      ? TextFormField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    hintText: "Choose university"
                  ),
                    onTap: () {
                      loadJsonFile(false, false, false , false);
                    },)
                      : Container(
                    padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select University ',
                        border: OutlineInputBorder( // Border like a TextField
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when not focused
                            width: 1.5,
                            // Border width when not focused
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when focused
                            width: 2.0, // Border width when focused
                          ),
                        ),
        
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the field
                      ),
                        onChanged: (newUniversity) {
                        setState(() {
                          selectedUniversity = newUniversity!;
                          CityItems = [];
                          CityItemsD = [];
                          selectedCity = "";
                          SchoolItems = [];
                          SchhoolItemsD = [];
                          selectedSchool = "";
                          FieldItems = [];
                          FieldItemsD = [];
                          selectedField = "";
                          loadJsonFile(true, false, false , false);
                        });
                                        },
                                        items: universityItemsD,
                                        value: selectedUniversity.isNotEmpty ? selectedUniversity : null,
                                        hint: Text('Select a university'),
                                      ),
                      ),
                ),
        
              ),
        
              /// City
              CityItems.isEmpty?SizedBox():
              Container(
                padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Select City ',
                    border: OutlineInputBorder( // Border like a TextField
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.green, // Border color when not focused
                        width: 1.5,
                        // Border width when not focused
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.green, // Border color when focused
                        width: 2.0, // Border width when focused
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the field
                  ),
                    onChanged: (Ncity){
                      setState(() {
                        selectedCity = Ncity! ;
                        SchoolItems = [];
                        SchhoolItemsD = [];
                        selectedSchool = "";
                        FieldItems = [];
                        FieldItemsD = [];
                        selectedField = "";
                        loadJsonFile(true, true, false , false);
                      });
                    },
                  items:CityItemsD ,
                  value: CityItems.isNotEmpty ? selectedCity : null,
                  isExpanded: true, // Make the dropdown fill the width
                  dropdownColor: Colors.white,
                ),
              ),
        
              SizedBox(height: 20,),
        
              /// School
              SchoolItems.isEmpty
                  ? SizedBox()
                  : Container(
                padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                    labelText: 'Select School',  // Label like in a TextField
                    border: OutlineInputBorder( // Border like a TextField
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.green, // Border color when focused
                        width: 2.0, // Border width when focused
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the field
                      ),
                                  onChanged: (Nschool) {
                    setState(() {
                      selectedSchool = Nschool!;
                      FieldItems = [];
                      FieldItemsD = [];
                      selectedField = "";
                      loadJsonFile(true, true, true, false);
                    });
                                  },
                                  items: SchhoolItemsD,
                                  value: SchoolItems.isNotEmpty ? selectedSchool : null,
                                  isExpanded: true, // Make the dropdown fill the width
                                  dropdownColor: Colors.white, // Background color of dropdown
                                ),
                  ),
        
              const SizedBox(height: 20,),
        
              /// Field
              FieldItems.isEmpty?SizedBox():
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Select field ',
                        border: OutlineInputBorder( // Border like a TextField
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when not focused
                            width: 1.5,
                            // Border width when not focused
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when focused
                            width: 2.0, // Border width when focused
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the field
                      ),
                        onChanged: (NField){
                          setState(() {
                            selectedField =NField! ;
                            weight_factorItems = [];
                            weight_factorItemsD = [];
                            selectedweight_factorItems = "";
                            loadJsonFile(true, true, true ,true);
                          });
                     },
                      items: FieldItemsD,
                      value: FieldItems.isNotEmpty ? selectedField : null,),
                  ),
        
              const SizedBox(height: 20,),
        
              (weight_factorItemsD.isEmpty ) ? const SizedBox() :(!fieldSelect.isNotEmpty)?
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select bac field  ',
                        border: OutlineInputBorder( // Border like a TextField
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when not focused
                            width: 1.5,
                            // Border width when not focused
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.green, // Border color when focused
                            width: 2.0, // Border width when focused
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the field
                      ),
                                  items: weight_factorItemsD,
                                  onChanged: (newValue) {
                    setState(() {
                      selectedweight_factorItems = newValue!;
                    });
                                  },
                                  value: selectedweight_factorItems,
                                  hint: const Text('Select a weight factor'),
                                ),
                  ):SizedBox(),
        
              const SizedBox(height: 20,),
        
              // the button to save
              (selectedweight_factorItems.isEmpty )?SizedBox():
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0 , 10 , 20 , 10),
                    child: ElevatedButton(
                    onPressed: () async{
        
                      final document = await firestoreService.getDocumentIdByIdentifier( user.email.toString() , 'students' , 'email');
                      final docIDStudent = document?.id;
                      final document1 = await firestoreService.getDocumentIdByIdentifier( selectedSchool , 'schools', 'name');
                      final docID = document1?.id;
                      try {
                        await firestoreService.addstudentsDOC(user.email.toString() ,
                                                            selectedSchool.toString() ,
                                                            selectedField.toString(),
                                                            selectedweight_factorItems.toString(),
                                                            selectedUniversity.toString() ,
                                                            selectedCity.toString() ,
                                                            NnoteController.text ,
                                                            RnoteController.text ,
                                                            noteOfBacController.text ,
                                                            weight_factorItemsValues[selectedweight_factorItems] , selectedweight_factorItems);
                        // add it to students
                        firestoreService.addItemToNestedArray (
                                                              docIDStudent.toString() ,
                                                              {
                                                                'field': selectedField.toString() ,
                                                                'note':(NnoteController.text.isNotEmpty && RMark == ''  && NMark == '')?
                                                                ((num.parse(NnoteController.text)*0.75+num.parse(RnoteController.text)*0.25)*weight_factorItemsValues[selectedweight_factorItems]).toStringAsFixed(2)
                                                                :((num.parse(NMark)*0.75+num.parse(RMark)*0.25)*weight_factorItemsValues[selectedweight_factorItems]).toStringAsFixed(2)
                                                              },
                                                              selectedSchool.toString() ,'students' ,'school', 'email' , 'name' ,
                                                              selectedUniversity.toString() ,
                                                              selectedCity.toString()  );
        
                        // add it to school
                        firestoreService.addItemToNestedArray (
                                                              docID.toString()  ,
                                                              {
                                                                'field': selectedField.toString() , 'note': (NMark == '' || RMark == '' )?
                                                              ((num.parse(NnoteController.text)*0.75+num.parse(RnoteController.text)*0.25)*weight_factorItemsValues[selectedweight_factorItems]).toStringAsFixed(2)
                                                              :((num.parse(NMark)*0.75+num.parse(RMark)*0.25)*weight_factorItemsValues[selectedweight_factorItems]).toStringAsFixed(2)
                                                              },
                                                              user.email.toString() ,'schools' ,'student', 'university' , 'student email' ,
                                                              selectedUniversity.toString() ,
                                                              selectedCity.toString() );
                      } catch (e) {
                        print(e);
                      }
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          shadowColor: Colors.white,
                          padding: const  EdgeInsets.symmetric(horizontal: 140  , vertical: 18 ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                    child: Text("Save" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black87 , fontSize: 18),)),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
