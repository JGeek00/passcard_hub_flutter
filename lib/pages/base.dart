import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:pass_flutter/pass_flutter.dart';


import 'package:buswallet/widgets/add_pass_menu.dart';
import 'package:buswallet/widgets/insert_url_dialog.dart';
import 'package:buswallet/models/app_screen.dart';
import 'package:buswallet/pages/passes.dart';
import 'package:buswallet/pages/settings.dart';
import 'package:buswallet/widgets/botttom_nav_bar.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late List<PassFile?> passes = [];

  int renderingPage = 0;

  void _navigateBottomNavBar(int page) {
    setState(() {
      renderingPage = page;
    });
  }

  @override
  void initState() { 
    super.initState();
    _getAllPasses();
  }

  void _getAllPasses() async {
    List<PassFile?> files = await Pass().getAllSaved();
    passes = files;
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pase guardado correctamente"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selección de fichero cancelada"),
        ),
      );
    }
  }

  void _downloadFromUrl(String url) async {
    PassFile passFile = await Pass().saveFromUrl(url: url);
    passFile.save();

    setState(() {
      passes.add(passFile);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pase guardado correctamente"),
      ),
    );
  }

  void _removePass(PassFile pass) async {
    List<PassFile> files = await Pass().delete(pass);
    setState(() {
      passes = files;
    });
  } 

  void _addPass() {
    showModalBottomSheet(
      context: context, 
      builder: (context) => AddPassMenu(
        context: context,
        fromLocalFile: _pickFiles,
        fromUrl: _showFromUrlDialog,
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true
    );
  }  

  Future<void> _showFromUrlDialog() async {
    final TextEditingController controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InsertUrlDialog(controller: controller, getFromUrl: _downloadFromUrl);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AppScreen> screens = [
      AppScreen(
        name: "Pases", 
        icon: const Icon(Icons.local_activity), 
        screen: Home(
          passes: passes, 
          removePass: _removePass
        ),
      ),
      const AppScreen(name: "Ajustes", icon: Icon(Icons.settings), screen: Settings()),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        body: SafeArea(child: screens[renderingPage].screen),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavBar(
          navBarScreens: screens, 
          onTap: _navigateBottomNavBar, 
          selectedScreen: renderingPage,
        ),
        floatingActionButton: renderingPage == 0 ? (
          FloatingActionButton(
            onPressed: _addPass, 
            child: const Icon(Icons.add),
          )
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}