import 'package:flutter/services.dart';
import 'package:real_project/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final _formKey = GlobalKey<FormState>();
class crete_new_acount extends StatefulWidget {
  crete_new_acount ({super.key});

  @override
  State<crete_new_acount> createState() => _crete_new_acountState();
}

class _crete_new_acountState extends State<crete_new_acount> {

  // define the controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();


  /// sign user up method
  void createAccount() async {
    /// show a login circle
    showAdaptiveDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // try sign in
    try {
      if (passwordController.text == confirmpasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text ,);
        print(' I am inside to create a New account');
        Navigator.pop(context);
        Navigator.push(
          context , MaterialPageRoute(builder: (context)=> auth_page() ) );
      }
      else{
        // show error messege
        showErrorMessege('not the same password');
        Navigator.pop(context);
        Navigator.pop(context);
      }

      // pop the loading circle

    }
    on FirebaseAuthException catch (e){
      // print('inside the on fire'+e.code);
      Navigator.pop(context);

      // wrong Email
      showErrorMessege(e.code);
    }
  }

  /// Wrong  email  message
  void showErrorMessege (String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog (
            title: Center(
              child: Text(
                  message
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('PickSchool', style: TextStyle(
          color:Colors.black ,
          fontWeight:  FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.green[400],

        actions: [
          IconButton(
              onPressed:(){
                Navigator.pop(context);
              },
              icon:  const Icon( Icons.logout , color: Colors.black,))
        ],

      ) ,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [

               const  SizedBox(height: 20,),


                // image of create account

                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Image.asset('assets/image/img_4.png' , )
                ),

                SizedBox(height: 10,),

                // email of student *_*
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email , color: Colors.grey,),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Email";
                      }
                      bool emailValid = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value);
                      if (!emailValid) {
                        return "Enter a valid Email";
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),

                // password of student...*_*
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText:true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock , color: Colors.grey,),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.white),),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),) ,
                      fillColor: Colors.white,
                      filled: true ,
                      hintText:  'Password',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(35),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if(value.toString().length < 6){
                        return "Enter a powerful password  ";
                      }
                      return null;
                    },
                  ),
                ) ,

                // confirm password   *_*
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: confirmpasswordController,
                    obscureText:true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock ,color: Colors.grey,),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.white),),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),) ,
                      fillColor: Colors.white,
                      filled: true ,
                      hintText:  ' Confirm Password',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(35),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the password";
                      }if(value.toString().length < 6){
                        return "Enter a powerful password  ";
                      }
                      return null;
                    },
                  ),
                ) ,

                SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: ()  {
                  if (_formKey.currentState?.validate() ?? false){
                    createAccount();
                    print('your are try to create an account in fire  auth');}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400], // Background color
                    shadowColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 12), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const  Text('Sign In',style: TextStyle(
                    color:Colors.black ,
                    fontWeight: FontWeight.bold ,
                    fontSize: 16
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



