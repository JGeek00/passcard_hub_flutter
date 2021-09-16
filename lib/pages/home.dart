import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/components/card.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      PassFile passFile = await Pass().saveFromFile(file: file);
      passFile.save();
      print(passFile);
    } else {
      // User canceled the picker
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _pickFiles(), 
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            )
          )
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CardWidget(),
        itemCount: 5,
      )
      
    );
  }
}