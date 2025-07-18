import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatefulWidget{
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    File ? image;
    ImagePicker picker =ImagePicker();
    savedImage() async{
      final picked =await picker.pickImage(source: ImageSource.camera);
      image= File(picked!.path);
      setState(() {

      });
    }
    return Scaffold(
      body: Column(
        children: [
          image==null?Text("no image"):Image.file(image!),
          IconButton(onPressed: (){
savedImage();
          },
              icon: Icon(Icons.add_a_photo, size:  60,)
          )
        ],
      ),
    );
  }
}