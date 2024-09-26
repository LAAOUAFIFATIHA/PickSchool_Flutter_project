import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'create_new_account.dart';
import 'home.dart';



class login_page extends StatefulWidget {
   login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {

   // define controllers
  final emailController = TextEditingController();
   final passwordController = TextEditingController();

   // define function ONTAB
  void signUserIn() async {
    // Show a loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitFadingCube(
            color: Colors.grey,
            size: 50.0,
          ),
        );
      },
    );

    // Try sign-in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Pop the loading circle once sign-in is successful
      Navigator.pop(context);

      // Proceed to the next screen or update the UI
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()), // Your next page here
      );

    } on FirebaseAuthException catch (e) {
      // Pop the loading circle in case of an error
      Navigator.pop(context);

      // Show an error message
      showDialog_message(e.code);
    }
  }


  // Wrong  email  message
  void showDialog_message (String message){
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('PickSchool',style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ) ,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
             const  SizedBox(height: 20,),

              // image of login
              Container(
                padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
               child:
                  Row(
                      children: [
                        Expanded(child: Image.asset('assets/image/login.png'  ,  fit: BoxFit.cover  /* the image will cover the row*/ , height: 280,))
                      ] ),

              ),

            const SizedBox(height: 20,),

              // email of student *_*
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email , color: Colors.grey[400],),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(9)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Email',
                  ),
                ),
              ),

              // password of student...*_*
              Padding(
                padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: passwordController,
                      obscureText:true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock , color: Colors.grey[400],),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.white  ,),
                      borderRadius: BorderRadius.circular(9)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:BorderSide(color: Colors.green),) ,
                      fillColor: Colors.white,
                      filled: true ,
                      hintText:  'Password',
                    ),
                  ),
              ) ,

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async{

                      // show a login circle
                      showAdaptiveDialog(
                          context: context,
                          builder: (context){
                            return const Center(
                              child: Center(
                                  child: SpinKitFadingCube(
                                    color: Colors.grey,
                                    size: 50.0,
                                  )),
                            );
                          });

                      // send message by email to reset password
                      if(emailController.text.isNotEmpty){
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                      Navigator.pop(context);
                      showDialog_message('check your email to rest password');
                      } else{
                        Navigator.pop(context);
                        showDialog_message('Please write your email');
                      }
                    },
                    child: Text('forget password ?', style: TextStyle(
                        color: Colors.green[600]
                    ),),
                  ),
                ],
              ),

              SizedBox(height:15 ,) ,

              ElevatedButton(
                  onPressed: () {
                     signUserIn() ;
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  shadowColor: Colors.white,
                  padding: const  EdgeInsets.symmetric(horizontal: 140  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                  child: const Text('Sign in', style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold ,
                    fontSize: 16
                  ),),
          
              ) ,

              SizedBox(height: 60 ,) ,

              //creat a new account
              GestureDetector(
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => crete_new_acount()),
                );},
                  child: Text('Crete New account ', style: TextStyle(
                    color: Colors.green[600] ,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold
                  ),))

            ],
          ),
        ),
      ),
    );
  }
}
