import 'package:flutter/material.dart';

Widget textButton(String text){
  return GestureDetector(
    onTap: (){

    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.withOpacity(.8),
      child: Text(text),
    ),
  );
}