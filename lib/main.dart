import 'package:buswallet/screens/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:pass_flutter/pass_flutter.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/config/theme.dart';
import 'package:buswallet/providers/app_config_provider.dart';
import 'package:buswallet/providers/categories_provider.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/screens/splash.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  ).then((value) async {
    Map<String, dynamic> dbData = await loadDb();
    List<PassFile?> passes = await getAllPasses();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CategoriesProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AppConfigProvider(),
          ),
          ChangeNotifierProxyProvider<CategoriesProvider, PassesProvider>(
            create: (context) => PassesProvider(), 
            update: (context, categoriesProvider, passesProvider) => passesProvider!..update(categoriesProvider),
          ),
        ],
        child: BusWallet(
          passes: passes,
          config: dbData['settings'],
          categories: dbData['categories'],
          archived: dbData['archived'],
          db: dbData['db'],
        ),
      )
    );
  });
}

Future<List<PassFile?>> getAllPasses() async {
  return  await Pass().getAllSaved();
}

Future<Map<String, dynamic>> loadDb() async {
  List<Map<String, Object?>>? config;
  List<Map<String, Object?>>? categories;
  List<Map<String, Object?>>? archived;

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
          config = await txn.rawQuery(
            'SELECT * FROM settings',
          );
         
        });
        await db.transaction((txn) async{
          categories = await txn.rawQuery(
            'SELECT * FROM categories',
          );
         
        });
        await db.transaction((txn) async{
          archived = await txn.rawQuery(
            'SELECT id FROM passes WHERE status = "archived"',
          );
        
        });
      }
    );

    return {
      "settings": config,
      "categories": categories,
      "archived": archived,
      "db": db
    };
}
class BusWallet extends StatefulWidget {
  final List<PassFile?> passes;
  final List<Map<String, Object?>> config;
  final List<Map<String, Object?>>categories; 
  final List<Map<String, Object?>> archived;
  final Database db;

  const BusWallet({
    Key? key,
    required this.passes,
    required this.config,
    required this.categories,
    required this.archived,
    required this.db
  }) : super(key: key); 

  @override
  State<BusWallet> createState() => _BusWalletState();
}

class _BusWalletState extends State<BusWallet> {
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode? active;
  DisplayMode? preferred;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    try {
      modes = await FlutterDisplayMode.supported;
    } on PlatformException catch (_) {
      /// e.code =>
      /// noAPI - No API support. Only Marshmallow and above.
      /// noActivity - Activity is not available. Probably app is in background
    }

    preferred = await FlutterDisplayMode.preferred;

    active = await FlutterDisplayMode.active;

    await FlutterDisplayMode.setHighRefreshRate();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final passesProvider = Provider.of<PassesProvider>(context, listen: false);
    final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    final configProvider = Provider.of<AppConfigProvider>(context);

    passesProvider.saveInitialPasses(widget.passes);
    configProvider.setConfig(widget.config);
    categoriesProvider.saveFromDb(widget.categories);
    passesProvider.setArchivedPasses(widget.archived);
    categoriesProvider.setDbInstance(widget.db);
    configProvider.setDbInstance(widget.db);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buswallet',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: configProvider.themeMode,
      home: const Base(),
    );
  }
}