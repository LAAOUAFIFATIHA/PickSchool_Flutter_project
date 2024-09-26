import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:real_project/pages/home.dart';
import '../services/fire_store.dart';
import '../services/profileService.dart';
import 'AddInformation/ContinueInf.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService firestoreService = FirestoreService();
  final ProfileService profileService = ProfileService();
  final textController = TextEditingController();
  Uint8List? image;

  Stream<Map<String, dynamic>> getDocumentFieldsStream() async* {
    try {
      Map<String, dynamic> data = await profileService.getArrayFieldStream();
      yield data;
    } catch (e) {
      yield {};
    }
  }


  /// To update items
  void openDailog(field, chosen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextFormField(
          controller: textController,
          decoration: InputDecoration(
            hintText: chosen.toString(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final document = await firestoreService.getDocumentIdByIdentifier(user.email.toString(), 'students', 'email');
              final documentId = document?.id;
              Navigator.pop(context);
              profileService.updateInformation(documentId, field, textController.text);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  ///  to pick the image
  pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    XFile? _pickedFile = await _picker.pickImage(source: source);

    if (_pickedFile != null) {
      return _pickedFile.readAsBytes();
    } else {
      print('No image selected.');
    }
  }

  /// to take the image
  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(()  {
      image = img;
    });
  }

  /// add the image to firebase
  void saveProfile() async {
    if (image != null) {
      String resp = await profileService.addImageToProfile(image!);
    }
  }

  /// open the dialog box to update the image
  void openDialogToUpdateImage() async{
    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: ' You want to update profile image \n are you sure ?'
            ),
          ),
          actions: [
          ElevatedButton(
              onPressed: (){ if (image != null){
                  profileService.updateImage(image!);
                  print('here the we update this image ');
                  Navigator.pop(context);
              }}, child: Text("yes")),
          ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, child: Text("No"))

          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: getDocumentFieldsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitFadingCube(
                color: Colors.grey,
                size: 50.0,
              ));
        } else {
          Map<String, dynamic> _Information = snapshot.data ?? {};
          return Scaffold(
            backgroundColor: Colors.green[50],

            /// the top of function
            appBar: AppBar(
              backgroundColor: Colors.green[400],
              title: const Text('PickSchool' , style: TextStyle(color: Colors.black87 , fontWeight: FontWeight.bold),),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => home()),
                    );
                  },
                  icon:const Icon(Icons.home, size: 30, color: Colors.black87),
                )
              ],
            ),

            body: SafeArea(
              child: ((_Information['name'] != null && _Information['note'] != "")) ? Column(
                children: [
                  SizedBox(height: 20,),
                  Stack(
                    children: [
                      _Information['profile image'] != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(_Information['profile image']!),
                      )
                          : CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage("assets/img.png"),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: ()async {
                            selectImage();
                            await Future.delayed(Duration(seconds: 2));
                            if (_Information['profile image'] != null  ) {
                              saveProfile();
                              openDialogToUpdateImage();
                              print('in if   function ');

                            } else {
                              print('in else function ');
                              saveProfile();
                            }
                          },
                          icon: Icon(Icons.add_a_photo, color: Colors.black, size: 30,),
                        ),
                        bottom: -10,
                        left: 80,
                      )
                    ],
                  ),

                  Text(user.email.toString(), style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),),

                  SizedBox(height: 18,),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Card(
                          child: ListTile(
                            title: Text("Name: " + (_Information['name'] ?? 'N/A')),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  openDailog('name', _Information['name'] ?? 'N/A');
                                }, icon: Icon(Icons.update)),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            title: Text("Last name: " + (_Information['last name '] ?? 'N/A')),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  openDailog('last name ', _Information['last name '] ?? 'N/A');
                                }, icon: Icon(Icons.update)),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            title: Text("Field: " + (_Information['field'] ?? 'N/A')),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  openDailog('field', _Information['field'] ?? 'N/A');
                                }, icon: Icon(Icons.update)),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            title: Text("Note: " + (_Information['note'] ?? 'N/A')),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  openDailog('note', _Information['note'] ?? 'N/A');
                                }, icon: Icon(Icons.update)),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            title: Text("Level: " + (_Information['level'] ?? 'N/A')),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  openDailog('level', _Information['level'] ?? 'N/A');
                                }, icon: Icon(Icons.update)),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ) : Column(
                children: [
                  Container(
                    child: Lottie.asset(
                          'assets/json/profileAddInfo.json'
                    ),
                  ),
                  Center(
                    child: ElevatedButton(

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContinueInf()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shadowColor: Colors.white,
                        padding: const  EdgeInsets.symmetric(horizontal: 60  , vertical: 15 ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text("Add information to your profile" , style:  TextStyle( color: Colors.black87 , fontWeight: FontWeight.bold),),

                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}