import 'package:chat/view/chat.dart';
import 'package:chat/view/group.dart';
import 'package:chat/view/searchpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homeview extends StatefulWidget {
  const Homeview({Key? key}) : super(key: key);

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User signedinuser;
  List<Map> listofUser =[];
  void getuser(){
    try {
      final user = auth.currentUser;
      if(user != null){
        signedinuser = user;
        print("signed user ${signedinuser.email}");
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: Icon(Icons.menu),
        title: Text("ChitChat"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Searchpage(logined_user: signedinuser.email),));
              },
                child: Icon(Icons.search,)),
          ),
          IconButton(onPressed: (){
            auth.signOut(); 
            Navigator.pop(context);
          }, icon: Icon(
              Icons.logout
          ))
        ],
      ),
      body: Stack(
        children:[ Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(!snapshot.hasData){
                    return Text("no data");
                  }
                  listofUser.clear();
                  snapshot.data!.docs.forEach((e){
                    // print(e.get("username"));
                    if(signedinuser.email!=e.get("email")){
                      listofUser.add({"username":e.get("username"),"email":e.get("email")});
                      // print(listofUser);
                    }
                  });
                  return ListView.builder(
                    itemCount: listofUser.length,
                    itemBuilder: (context, index) {

                      var name = snapshot.data!.docs[index].get("username");
                      var email = snapshot.data!.docs[index].get("email");
                      // print("signed user${signedinuser.email}");

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chat(Email: listofUser[index]["email"], Name: listofUser[index]["username"]),));
                          },
                          child:Container(
                            height: 70,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20)
                            ),child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child:Text(listofUser[index]["username"], style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                ),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Group_page(login_user: signedinuser,)));
                },
                    icon: Icon(Icons.add_circle, color: Colors.orange[700],size: 45,))
              ],
            )
          ],
        ),
      ]),
    );
  }
}
