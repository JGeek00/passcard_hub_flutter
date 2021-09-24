import 'package:buswallet/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/providers/app_config_provider.dart';
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
    final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    final configProvider = Provider.of<AppConfigProvider>(context, listen: false);

    final Database db = await openDatabase(
      'passes.db', 
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE categories (id TEXT PRIMARY KEY, name TEXT, dateFormat TEXT, path TEXT, pathIndex INTEGER, items TEXT)');
        await db.execute('CREATE TABLE passes (id TEXT PRIMARY KEY, status TEXT)');
        await db.execute('CREATE TABLE settings (config PRIMARY KEY, value TEXT)');
        await db.execute('INSERT INTO settings (config, value) VALUES ("theme", ?)', ['system']);
      },
      onOpen: (Database db) async {
        await db.transaction((txn) async{
          var config = await txn.rawQuery(
            'SELECT * FROM settings',
          );
          configProvider.setConfig(config);
        });
        await db.transaction((txn) async{
          var categories = await txn.rawQuery(
            'SELECT * FROM categories',
          );
          categoriesProvider.saveFromDb(categories);
        });
        await db.transaction((txn) async{
          var archived = await txn.rawQuery(
            'SELECT id FROM passes WHERE status = "archived"',
          );
          passesProvider.setArchivedPasses(archived);
        });
      }
    );
    categoriesProvider.setDbInstance(db);
    configProvider.setDbInstance(db);
  }

  void _loadData(passesProvider) async {
    final passesProvider = Provider.of<PassesProvider>(context, listen: false);
    await _loadCategories(context);
    await _getAllPasses(passesProvider.savePasses);
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => const Base())
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/icon/buswallet-logo.png'),
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}