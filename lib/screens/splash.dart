import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/screens/base.dart';
import 'package:buswallet/providers/passes_provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future _getAllPasses(void Function(List<PassFile?> savePasses) savePasses) async {
    List<PassFile?> files = await Pass().getAllSaved();
    savePasses(files);
  }

  Future _loadCategories(BuildContext context) async {
    final passesProvider = Provider.of<PassesProvider>(context, listen: false);
    final Database db = await openDatabase(
      'passes.db', 
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE categories (id TEXT PRIMARY KEY, name TEXT, dateFormat TEXT, items TEXT)');
      },
      onOpen: (Database db) async {
        await db.transaction((txn) async{
          var result = await txn.rawQuery(
            'SELECT * FROM categories',
          );
          passesProvider.saveFromDb(result);
        });
      }
    );
    passesProvider.setDbInstance(db);
  }

  void _loadData(passesProvider) async {
    final passesProvider = Provider.of<PassesProvider>(context, listen: false);
    await _getAllPasses(passesProvider.savePasses);
    await _loadCategories(context);
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => const Base())
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Text("Bus Wallet"),
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}