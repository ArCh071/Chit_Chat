import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class Chat extends StatefulWidget {
   Chat({Key? key, required this.Name, required this.Email} ) : super(key: key);
String? Name;
String? Email;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController message = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User signedinuser;
  String msgtext = '';

  List Messages =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }
  void getmessage() async{
   await for (var snapshot in firestore.collection('message').snapshots()){
     for(var messages in snapshot.docs){
       print(messages.data());
     }
   }

  }

  void getcurrentuser(){
    try {
      final user = auth.currentUser;
      if(user != null){
        signedinuser = user;
        print(signedinuser.email);
      }
    } on Exception catch (e) {
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(widget.Name.toString()),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blueGrey[100],
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('message').orderBy('time').snapshots(),
                builder: (context, snapshot){
                List<Msges> messagewidgets = [];
                if(!snapshot.hasData){
                  return Text("no data");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final message = snapshot.data!.docs;
                for(var messages in message){
                   msgtext = messages.get('text');
                  final msgsender = messages.get('sender');
                  final currentuser = signedinuser.email;
                  final receiver = messages.get('receiver');
                  if(currentuser == receiver && widget.Email == msgsender || currentuser == msgsender && widget.Email == receiver){
                    // print("${receiver}...........rr....."); print("${currentuser}..ss..............");
                    // print("${msgtext}");
                    final messagewidget = Msges(
                      text: msgtext,
                      sender: msgsender,
                      istrue: currentuser == msgsender,
                    );
                    messagewidgets.add(messagewidget);

                  }
                  if(currentuser == msgsender){
                   // print("${currentuser}................");
                  }

                }
                return Expanded(
                  child: ListView(
                    children: messagewidgets,
                  ),
                );
                }),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 330,
                  child: TextField(maxLines: 50,minLines: 1,
                   controller: message,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),borderRadius: BorderRadius.circular(20)
                        ),
                      hintText: 'Write your message here..',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  firestore.collection('message').add({
                    'text': message.text,
                    'sender': signedinuser.email,
                    'time': FieldValue.serverTimestamp(),
                    'receiver': widget.Email
                  });
                  message.clear();
                }, icon: Icon(Icons.send_rounded, color: Colors.orange[700],size: 25,))
              ],
            )
          ],
        ),
      ),
    );
  }
}


