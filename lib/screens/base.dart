import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/utils/passes.dart';
import 'package:buswallet/widgets/add_pass_menu.dart';
import 'package:buswallet/models/app_screen.dart';
import 'package:buswallet/screens/passes.dart';
import 'package:buswallet/screens/settings.dart';
import 'package:buswallet/widgets/botttom_nav_bar.dart';

class Base extends StatefulWidget {
  const Base({
    Key? key,
  }) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late List<PassFile?> passes = [];
  int renderingPage = 0;
  String selectedFiltering = "all";

  void _navigateBottomNavBar(int page) {
    setState(() {
      renderingPage = page;
    });
  }

  void _openAddPassMenu() {
    showModalBottomSheet(
      context: context, 
      builder: (context) => AddPassMenu(
        fromDevice: _pickPassFromDevice,
        fromUrl: _pickPassFromUrl
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true
    );
  }  

  void _pickPassFromDevice() async {
    var result = await pickFiles(
      context: context, 
    );

    _createSkackbar(result['message'], result['color']);
  }

  void _pickPassFromUrl(String urlValue) async {
    var result = await downloadFromUrl(
      context: context, 
      url: urlValue
    );

    _createSkackbar(result['message'], result['color']);
  }

  void _createSkackbar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AppScreen> screens = [
      const AppScreen(
        name: "Pases", 
        icon: Icon(Icons.local_activity), 
        screen: Passes(),
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
            onPressed: _openAddPassMenu, 
            child: const Icon(Icons.add),
          )
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}