import 'package:chat/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signpage extends StatefulWidget {
  const Signpage({Key? key}) : super(key: key);

  @override
  State<Signpage> createState() => _SignpageState();
}

class _SignpageState extends State<Signpage> {
  @override
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static var email = TextEditingController();
  static var username = TextEditingController();
  static var pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text("Sign Up", style: TextStyle(
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
                      child: Text("Your information is safe with us", style: TextStyle(
                          color: Colors.white70, fontSize: 17
                      ),),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text("Username", style: TextStyle(
                          color: Colors.white, fontSize: 15,
                      ),),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    controller: username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
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
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Email Id";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
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
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                    controller: pass,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),),
                  ),
                  SizedBox(
                    height: 50,),
                  InkWell(
                    onTap: () async{
                      final valid = _formKey.currentState!.validate();
                      if (valid == true) {
                        var userdata =
                            await auth.createUserWithEmailAndPassword(
                            email: email.text, password: pass.text);
                        if(userdata != null){
                          await firestore.collection('users').add({
                            'email': email.text,
                            'username': username.text,
                            'uid': userdata.user!.uid
                          });
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Loginpage()));
                        final snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Sign Up Successfully"),
                            duration: Duration(seconds: 1));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      } else {
                        return;
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange[900],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Sign Up", style: TextStyle(
                          color: Colors.white, fontSize: 15
                        ),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
