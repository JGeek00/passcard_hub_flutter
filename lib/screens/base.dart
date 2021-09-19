import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/models/pass_category.dart';
import 'package:buswallet/utils/dates.dart';
import 'package:buswallet/widgets/add_pass_menu.dart';
import 'package:buswallet/widgets/insert_url_dialog.dart';
import 'package:buswallet/models/app_screen.dart';
import 'package:buswallet/screens/passes.dart';
import 'package:buswallet/screens/settings.dart';
import 'package:buswallet/widgets/botttom_nav_bar.dart';

class Base extends StatefulWidget {
  final List<PassFile?> passes;

  const Base({
    Key? key,
    required this.passes,
  }) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late List<PassFile?> passes = [];
  int renderingPage = 0;
  String selectedFiltering = "all";

  List<PassCategory> categories = [
    
  ];

  @override
  void initState() { 
    super.initState();

    _getFiles();
  }

  void _getFiles() {
    passes = sortPassDates(
      items: widget.passes, 
      field: 'auxiliaryFields', 
      index: 0
    );
  }

  void _navigateBottomNavBar(int page) {
    setState(() {
      renderingPage = page;
    });
  }

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      PassFile passFile = await Pass().saveFromFile(file: file);

      PassCategory? exists;
      for (var category in categories) {
        if (category.id == passFile.pass.passTypeIdentifier) {
          exists = category;
        }
      }

      if (exists != null) {
        exists.items.add(
          PassCategory(
            id: passFile.pass.passTypeIdentifier, 
            name: passFile.pass.organizationName, 
            items: [
              passFile.pass.serialNumber
            ]
          )
        );

        List<PassCategory> newCategories = categories.map((category) {
          if (category.id == exists!.id) {
            return exists;
          }
          else {
            return category;
          }
        }).toList();

        setState(() {
          categories = newCategories;
        });
      }
      else {
        setState(() {
          categories.add(
            PassCategory(
              id: passFile.pass.passTypeIdentifier, 
              name: passFile.pass.organizationName, 
              items: [
                passFile.pass.serialNumber
              ]
            )
          );
        });
      }

      try {
        DateTime date = DateFormat('dd-MM-yyyy HH-mm').parse(passFile.pass.boardingPass!.auxiliaryFields![0].value!);
        print(date);
      } catch (e) {
        print(e);
      }
      
      bool passExists = false;
      for (var pass in passes) {
        if (pass!.pass.serialNumber == passFile.pass.serialNumber) {
          passExists = true;
          break;
        }
      }

      if (passExists == false) {
        setState(() {
          passes.add(passFile);
          passes = sortPassDates(
            items: passes, 
            field: 'auxiliaryFields', 
            index: 0
          );
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pase guardado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      }
      else {
        _removePass(passFile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El pase no ha sido guardado porque ya existía"),
            backgroundColor: Colors.red,
          ),
        );
      }

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

  void _filterPasses(String? filterValue) {

  }

  @override
  Widget build(BuildContext context) {
    final List<AppScreen> screens = [
      AppScreen(
        name: "Pases", 
        icon: const Icon(Icons.local_activity), 
        screen: Passes(
          passes: passes, 
          categories: categories,
          removePass: _removePass,
          selected: selectedFiltering,
          onSelectFiter: _filterPasses,
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