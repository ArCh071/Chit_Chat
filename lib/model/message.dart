import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Msges extends StatelessWidget {
  const Msges({Key? key, this.text, required this.istrue,this.time, this.sender}) : super(key: key);
  final String? sender;
  final String? text;
  final DateTime? time;
  final bool istrue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            alignment: istrue?Alignment.topRight: Alignment.topLeft,
            child: Material(
                elevation: 5,
                borderRadius:
                istrue?BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ) : BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: istrue? Colors.orange[800] : Colors.black ,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text('$text', style: TextStyle(
                      color: Colors.white, fontSize: 15
                  ),),
                )),
          ),
        ],
      ),
    );
  }
}