import 'package:buswallet/widgets/botttom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/pass_page.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<PassFile?> passes = [];

  @override
  void initState() { 
    super.initState();
    _getAllPasses();
  }

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      PassFile passFile = await Pass().saveFromFile(file: file);
      passFile.save();

      setState(() {
        passes.add(passFile);
      });
    } else {
      // User canceled the picker
    }
  }

  void _getAllPasses() async {
    List<PassFile?> files = await Pass().getAllSaved();
    passes = files;
  }

  void _removePass(PassFile pass) async {
    List<PassFile> files = await Pass().delete(pass);
    setState(() {
      passes = files;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: passes.isNotEmpty ? (
          PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => PassPage(passFile: passes[index], removePass: _removePass),
            itemCount: passes.length,
          )
        ) : SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: (
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.local_activity,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  "No hay pases para mostrar",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey
                  ),
                ),
              ],
            )
          ),
        ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFiles, 
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}