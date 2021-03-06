import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passcard_hub/widgets/add_multiple_results_dialog.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/utils/navbar.dart';
import 'package:passcard_hub/utils/passes.dart';
import 'package:passcard_hub/widgets/add_pass_menu.dart';
import 'package:passcard_hub/models/app_screen.dart';
import 'package:passcard_hub/screens/passes.dart';
import 'package:passcard_hub/screens/settings.dart';
import 'package:passcard_hub/widgets/botttom_nav_bar.dart';
import 'package:passcard_hub/providers/app_config_provider.dart';

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
    final configProvider = Provider.of<AppConfigProvider>(context, listen: false);

    showModalBottomSheet(
      context: context, 
      builder: (context) => AddPassMenu(
        fromDevice: _pickPassFromDevice,
        fromUrl: _pickPassFromUrl
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true
    ).whenComplete(() => configProvider.setModalBottomSheetStatus(false));

    configProvider.setModalBottomSheetStatus(true);
  }  

  void _pickPassFromDevice() async {
    var result = await pickFiles(
      context: context, 
    );

    if (result['type'] == 'snackbar') {
      _createSkackbar(result['message'], result['color']);
    }
    else if (result['type'] == 'modal') {
      showDialog(
        context: context, 
        builder: (context) => AddMultipleResultsDialog(
          results: result['results'],
        ),
      );
    }
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
        margin: const EdgeInsets.all(10),
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<AppConfigProvider>(context);

    final List<AppScreen> screens = [
      const AppScreen(
        name: "Pases", 
        icon: Icon(Icons.local_activity), 
        screen: Passes(),
      ),
      const AppScreen(name: "Ajustes", icon: Icon(Icons.settings), screen: Settings()),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: getColorForNavBar(context),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: configProvider.themeMode == ThemeMode.light ? (
          Brightness.dark
        ) : (
          Brightness.light
        ),
        systemNavigationBarIconBrightness: configProvider.themeMode == ThemeMode.light ? (
          Brightness.dark
        ) : (
          Brightness.light
        ),
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