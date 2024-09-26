import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'fire_store.dart';


class  ProfileService {

  /*  get  */

  /// get the instance of firestoreService class
  final FirestoreService firestoreService = FirestoreService();

  ///  get the information from fireStore
  Future<Map<String, dynamic>> getArrayFieldStream() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final documentSnapshot = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email');
    final docID = documentSnapshot?.id;

    DocumentReference documentRef = firestore.collection('students').doc(docID);
    DocumentSnapshot snapshot = await documentRef.get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data;
  }

  /* add */

  /// transfer the image to URL
  Future<String> uploadImageToStorage( Uint8List image) async {
    try {
      /// Create a reference to the location in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('profile image');

      /// Upload the image data
      UploadTask uploadTask = ref.putData(image);

      ///Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  /// add information to fireStore
  void addFieldToDocument( collection , name  ,lastName , note  , age) async {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser! ;
    final  documentSnapshot = await firestoreService.getDocumentIdByIdentifier(user.email.toString() , 'students' , 'email');
    final docID = documentSnapshot?.id;
    // Reference to the specific document you want to update
    DocumentReference documentRef = firestore.collection(collection).doc(docID);

    // New field to add
    Map<String, dynamic> newField = {
      'name': name.toString(),
      'last name ': lastName.toString(),
      'note': note.toString(),
      'age' : age.toString(),
    };

    try {
      // Update the document with the new field
      await documentRef.update(newField);
      print('Field added successfully');
    } catch (e) {
      print('Error adding field: $e');
    }
  }

  /// add profile image
   addImageToProfile( Uint8List image ) async {
    if (image !=null) {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser!;
      final documentSnapshot = await firestoreService.getDocumentIdByIdentifier(
          user.email.toString(), 'students', 'email');
      final docID = documentSnapshot?.id;
      // Reference to the specific document you want to update
      DocumentReference documentRef = firestore.collection('students').doc(
          docID);
      try {
        String ImageUrl = await uploadImageToStorage( image);
        Map<String, dynamic> newField = {
          'profile image': ImageUrl,
        };

        try {
          // Update the document with the new field
          await documentRef.update(newField);
          print('Field added successfully');
        } catch (e) {
          print('Error adding field: $e');
        }
      } catch (r) {
        print('there is an error in loading image URL ${r}');
      }
    }
  }

  /*  update */

  /// update image
  void updateImage ( newValue ) async{
print("in the function of uoddating of image ");
    /// get collection reference
    CollectionReference collectionRef = await FirebaseFirestore.instance.collection("students");

    /// get the specific doC
    final user = FirebaseAuth.instance.currentUser! ;
    final  documentSnapshot = await firestoreService.getDocumentIdByIdentifier(user.email.toString() , 'students' , 'email');
    final docID = documentSnapshot?.id;
    String image = await uploadImageToStorage(newValue);

    ///  get document reference
    DocumentReference documentRef =  await collectionRef.doc(docID);

    ///  update the information
    try{
      await documentRef.update({'profile image': image});
      print("image  updated successful ");

    }catch(e){
      print("no updating  there is an error  "+e.toString());
    }
  }

  /// Function to update information
  void updateInformation(docId, field, newValue) async {
    /// Get collection reference
    CollectionReference collectionRef = FirebaseFirestore.instance.collection("students");

    /// Get document reference
    DocumentReference documentRef = collectionRef.doc(docId);

    /// Update the information
    try {
      await documentRef.update({field: newValue});
      print("This work successful");
    } catch (e) {
      print("No updating; there is an error: " + e.toString());
    }
  }


}

