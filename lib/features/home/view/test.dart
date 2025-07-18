import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    File ? image;
    ImagePicker picker =ImagePicker();
    savedImage() async{
      final picked =await picker.pickImage(source: ImageSource.camera);
      image= File(picked!.path);
    }
    return Scaffold(
      body: Column(
        children: [
          IconButton(onPressed: (){
            
          },
              icon: Icon(Icons.camera, size:  60,)
          )
        ],
      ),
    );
  }

}