import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pass_flutter/pass_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:passcard_hub/screens/base.dart';
import 'package:passcard_hub/config/theme.dart';
import 'package:passcard_hub/providers/app_config_provider.dart';
import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/providers/passes_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  ).then((value) async {
    AppConfigProvider appConfigProvider = AppConfigProvider();
    PassesProvider passesProvider = PassesProvider();
    CategoriesProvider categoriesProvider = CategoriesProvider();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> dbData = await loadDb();
    List<PassFile?> passes = await Pass().getAllSaved();

    appConfigProvider.setConfig(dbData['settings']);
    categoriesProvider.saveFromDb(dbData['categories']);
    passesProvider.setArchivedPasses(dbData['archived']);
    categoriesProvider.setDbInstance(dbData['db']);
    appConfigProvider.setDbInstance(dbData['db']);
    appConfigProvider.setAppVersion(packageInfo.version);

    passesProvider.saveInitialPasses(passes);
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => categoriesProvider,
          ),
          ChangeNotifierProvider(
            create: (context) => appConfigProvider,
          ),
          ChangeNotifierProxyProvider<CategoriesProvider, PassesProvider>(
            create: (context) => passesProvider, 
            update: (context, categoriesProvider, passesProvider) => passesProvider!..update(categoriesProvider),
          ),
        ],
        child: const BusWallet(),
      )
    );
  });
}

Future<Map<String, dynamic>> loadDb() async {
  List<Map<String, Object?>>? config;
  List<Map<String, Object?>>? categories;
  List<Map<String, Object?>>? archived;

  final Database db = await openDatabase(
      'passes.db', 
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE categories (id TEXT PRIMARY KEY, name TEXT, dateFormat TEXT, path TEXT, pathIndex INTEGER, items TEXT)');
        await db.execute('CREATE TABLE passes (id TEXT PRIMARY KEY, type TEXT, status TEXT)');
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

  const BusWallet({
    Key? key,
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
    final configProvider = Provider.of<AppConfigProvider>(context);
    final passesProvider = Provider.of<PassesProvider>(context, listen: false);

    passesProvider.sortPasses();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buswallet',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: configProvider.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', '')
      ],
      home: const Base(),
    );
  }
}