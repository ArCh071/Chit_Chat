import 'package:chat/view/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Searchpage extends StatefulWidget {
  Searchpage({Key? key, required this.logined_user}) : super(key: key);
  final logined_user;
  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  List<Map> searchresult = [];
  TextEditingController search = TextEditingController();
  bool isload = false;
  bool cleartxt = false;

  void onsearch() async {
    setState(() {
      searchresult = [];
      isload = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: search.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No user found")));
        setState(() {
          isload = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.logined_user) {
          searchresult.add(user.data());
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No user found")));

        }
      });
      setState(() {
        isload = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    // onTap: (){
                    //   setState(() {
                    //     cleartxt = true;
                    //   });
                    // },
                    controller: search,
                    decoration: const InputDecoration(
                        hintText: 'type username..',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.orange,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextButton(
                      onPressed: () {
                        onsearch();
                      },
                      child:
                          // cleartxt == true?IconButton(onPressed: (){
                          //   setState(() {
                          //     search.clear();
                          //   });
                          // }, icon: Icon(
                          //   Icons.clear, color: Colors.orange[700],)):
                          Text(
                        "search",
                        style: TextStyle(color: Colors.orange[700]),
                      )),
                ),
              ],
            ),
          ),
          if (searchresult.length > 0)
            Expanded(
              child: ListView.builder(
                  itemCount: searchresult.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Chat(
                              Name: searchresult[index]['username'],
                              Email: searchresult[index]['email']),
                        ));
                      },
                      child: ListTile(
                        title: Text(searchresult[index]['username']),
                        subtitle: Text(searchresult[index]['email']),
                        trailing: Icon(
                          Icons.message,
                          color: Colors.orange[700],
                        ),
                      ),
                    );
                  }),
            )
          else if (isload == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
