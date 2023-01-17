import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Group_page extends StatefulWidget {
   Group_page({Key? key, required this.login_user}) : super(key: key);
var login_user;
  @override
  State<Group_page> createState() => _Group_pageState();
}

class _Group_pageState extends State<Group_page> {
  List<Map> members = [];
  bool isSelected = false;
  var mycolor = Colors.grey;
  void selection_member() {
    setState(() {
      if (isSelected) {
        mycolor= Colors.grey;
        isSelected = false;
      } else {
        mycolor=Colors.orange;
        isSelected = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print(" logined alrdy ${widget.login_user}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text("create group"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Group name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
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
                  members.clear();
                  snapshot.data!.docs.forEach((e){
                    // print(e.get("username"));
                    if(widget.login_user.email!=e.get("email")){
                      members.add({"username":e.get("username"),"email":e.get("email")});
                      // print(listofUser);
                    }
                  });
                  return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {

                        var name = snapshot.data!.docs[index].get("username");
                        var email = snapshot.data!.docs[index].get("email");
                        // print("signed user${signedinuser.email}");

                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListTile(
                            selected: isSelected,
                            onLongPress: (){
                              selection_member();
                            },
                            title: Text(members[index]['username']),
                            subtitle: Text(members[index]['email']),
                            trailing:Icon(Icons.check_circle_outline),
                            ),
                        );
                      }
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
