import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  // get collection of notes *_*
  final CollectionReference students =
                            FirebaseFirestore.instance.collection('students');


        /* add  */
  // add student doc to collection
  Future<void> addstudentsDOC (String student , school ,field, fieldOfBac ,university  , city , Rnote , Nnote , note , weild_factor , fieldOfbac) async{
    QuerySnapshot querySnapshot =  await students.where('email' , isEqualTo: student).get();

    // Email already exists
    if (querySnapshot.docs.isNotEmpty){
      print('');
    }else{
      students.add({
        'email' : student ,
        'Rnote' : Rnote ,
        'Nnote' : Nnote ,
        'note' :  note ,
        'field': fieldOfbac ,
        'school' : [{"name":school , "field":[{'field':field , 'note':((num.parse(Nnote)*0.75+num.parse(Rnote)*0.25)*weild_factor).toStringAsFixed(2) }] , "univesity":university , "city" : city}],
      });}
  }


  //add items to a nested array
  void addItemToNestedArray( docID , Map newValue , school_OR_stdEmail , collection  , field , tool , tool2  , university , city ) async {
    print('inside this function  addItemToNestedArray');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentRef = firestore.collection(collection).doc(docID);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      List<dynamic> arrayField = documentSnapshot[field];

      // Find the index of the map where the name field matches the school
      int mapIndex = arrayField.indexWhere((map) => (  map['city'] == city) && map[tool2] == school_OR_stdEmail && map['univesity'] == university );

      if (arrayField.length >= 0 ) {

          // check the school exist
          if(mapIndex!= -1){
            if(mapIndex == null){
              print('here the error  mapIndex is null   ${mapIndex} ');
            }
            List<dynamic> nestedArray = arrayField[mapIndex]['field'];

            // check if the field is already exist
          int varField = nestedArray.indexWhere((map) => map['field'] == newValue['field']);

            if (varField == -1){
              nestedArray.add(newValue);
              await documentRef.update({
                field: nestedArray,
              }).then((_) {
                print('Item added to nested array successfully');
              }).catchError((error) {
                print('Failed to add item to nested array: $error');
              });}
          else {
              print('Item already exists in the nested array');}

          await documentRef.update({
            field: arrayField,
          }).then((_) {
            print('Item added to nested array successfully');
          }).catchError((error) {
            print('Failed to add item to nested array: $error');
      });}
        else{
          print('here to add to a nested array ...');
          Map<String, dynamic> newMap = {tool2: school_OR_stdEmail, "field": [newValue] , "univesity": university , "city" : city };
          arrayField.add(newMap);

          await documentRef.update({
            field: arrayField,
          }).then((_) {
            print('New school map added successfully');
          }).catchError((error) {
            print('Failed to add new school map: $error');
          });
        }
      } else {
        print('Invalid map index');
      }
    } else {
      print('Document does not exist ');
    }
  }


        /*  get  */
  // to get the id of the document that continue this email like identifier
  Future<DocumentSnapshot?> getDocumentIdByIdentifier(String identifier,collection , tool) async {
    try {
      // Reference to the Firestore collection
      CollectionReference students = FirebaseFirestore.instance.collection(collection);

      // Query the collection for the document with the specific identifier
      QuerySnapshot querySnapshot = await students.where( tool, isEqualTo: identifier).get(); // tool means the name of field we need

      // Check if a document is found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming identifiers are unique)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Return the document ID
        return documentSnapshot;
      }
      else {
        // If no document is found, return null
        return null;
      }
    } catch (e) {
      print('Error getting document ID: $e');
      return null;
    }
  }


        /*  remove  */
 // remove fields from array ***  ***  ***
  void removeItemToNestedArray( docID , newValue , school_OR_stdEmail , collection ,field ,  tool1 , tool2  , university , city) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentRef = firestore.collection(collection).doc(docID);

    DocumentSnapshot documentSnapshot = await documentRef.get();
    if (documentSnapshot.exists) {
      List<dynamic> arrayField = documentSnapshot[field];
      // Find the index of the map where the name field matches the school
      int mapIndex = arrayField.indexWhere((map) => map[tool2] == school_OR_stdEmail && map['univesity'] == university && map['city'] == city);

      if (arrayField.length >= 0 ) {
        // check the school exist
        if(mapIndex!= -1) {
          List<dynamic> nestedArray = arrayField[mapIndex]['field'];
          // check if the field is already exist
          int varField = nestedArray.indexWhere((map) => map['field'] == newValue['field'] && map['note'] == newValue['note'] );

          if (varField != -1) {
            nestedArray.removeAt(varField);
            await documentRef.update({ field: arrayField}).then((_) {
              print('Item removed from nested array successfully');
            }).catchError((error) {
              print('Failed removed from item to nested array: $error');
            });
          }
          else {
            print('Item already exists in the nested array');
          }
        }
      } else {
        print('Invalid map index');
      }
    } else {
      print('Document does not exist');
    }
  }


  // remove the hole school from students or the field of student from schools
  Future<void> removeItemFromArray(String documentId, dynamic itemToRemove, int index, String collectionName, String arrayFieldName) async {
    print("function removeItemFromArray3");
    try {
      // Retrieve the document snapshot
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection(collectionName).doc(documentId).get();

      if (!docSnapshot.exists) {
        print("Document does not exist.");
        return;
      }
      // Get the array of items from the document
      List<dynamic> itemsArray = List.from(docSnapshot.get(arrayFieldName) ?? []);

      // Ensure the index is valid before trying to remove
      if (index >= 0 && index < itemsArray.length) {
        itemsArray.removeAt(index);
      } else {
        print("Invalid index: $index");
        return;
      }
      // Update the document with the new array
      await FirebaseFirestore.instance.collection(collectionName).doc(documentId).update({arrayFieldName: itemsArray});
      print("Updated array: $itemsArray");
    } catch (e) {
      print("Error OH : $e");
    }
  }


}