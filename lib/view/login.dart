import 'package:chat/view/chat.dart';
import 'package:chat/view/home.dart';
import 'package:chat/view/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  var user1 ;
  var user2;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text("Hello Again !", style: TextStyle(
                  color: Colors.white,fontSize: 50,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text("Welcome back you are been missed", style: TextStyle(
                    color: Colors.white70, fontSize: 17
                ),),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text("Email address", style: TextStyle(
                    color: Colors.white, fontSize: 15
                ),),
              ),
            ),
            SizedBox(
              height: 5,
            ),
           Padding(
             padding: const EdgeInsets.only(left: 15, right: 15),
             child: TextField(
                    controller: email,
               style: TextStyle(
                   color: Colors.white
               ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
           ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text("Password", style: TextStyle(
                    color: Colors.white, fontSize: 15
                ),),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                  controller: pass,
                  obscureText: _isHidden,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden
                              ? Icons.visibility
                              : Icons.visibility_off,color: Colors.white,
                        ) ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintStyle: TextStyle(
                          color: Colors.white
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                ),
            ),
                SizedBox(
                  height: 50,
                ),

                InkWell(
                  onTap: ()async{
                    try {
                      var log=  await auth.signInWithEmailAndPassword(email: email.text, password: pass.text);
                      // Con.currentuser = log.user!.uid;
                      // print(Con.currentuser);
                      if(log != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Homeview( ),));
                      }
                    } on Exception catch (e) {
                     print(e);
                    }
                    // if(log != null){
                    //   String uid = log.user!.uid;
                    //   await FirebaseFirestore.instance.collection('users').doc('uid').set(
                    //       {
                    //         "email": email.text,
                    //         "uid": uid
                    //       });
                    //
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text("Sign in", style: TextStyle(
                            color: Colors.white, fontSize: 16
                        ),),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.orange[900],
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
               Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: TextStyle(
                                  color: Colors.white, fontSize: 15
                              ),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signpage(),));
                     }, child: Text("Sign up", style: TextStyle(
                      color: Colors.orange[800], fontSize: 15
                    ),))
                    ],
                  ),
              ],

        ),
      ),
    );
  }
}
