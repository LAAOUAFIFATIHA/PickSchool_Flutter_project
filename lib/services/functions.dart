import 'package:cloud_firestore/cloud_firestore.dart';

void addElement_to_array (documentSnapshot , index , newValue , docID , collection , field) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (documentSnapshot.exists) {
    List<dynamic> array = documentSnapshot.get(field);
    int  varbale = array.indexOf(newValue);

    if (array is List) {
      if (index >= 0 && index <= array.length) {
        if(varbale == -1){
        array.insert(index, newValue);}
      } else {
        // Handle the case where the index is out of bounds.
        print('Index out of bounds');
        return  ;
      }
      await firestore.collection(collection).doc(docID).update({
        field: array,
      });
    } else {
      // Handle the case where the field is not an array.
      print('Field is not an array');
    }
  }
  else {
    // Handle the case where the document does not exist.
    print('Document does not exist');
  }
}

void addElement_to_array_of_array (documentSnapshot , index , newValue , docID , collection , field , newField) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (documentSnapshot.exists) {
    List<dynamic> array = documentSnapshot.get(field);
    int  varbale = array[newValue].indexOf(newField);

    if (array is List) {
      if (index >= 0 && index <= array.length) {
        if(varbale == -1){
          array[newValue].insert(index, newField);}
      } else {
        // Handle the case where the index is out of bounds.
        print('Index out of bounds');
        return  ;
      }
      await firestore.collection(collection).doc(docID).update({
        field: array,
      });
    } else {
      // Handle the case where the field is not an array.
      print('Field is not an array');
    }
  }
  else {
    // Handle the case where the document does not exist.
    print('Document does not exist');
  }
}





