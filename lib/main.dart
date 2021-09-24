import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/config/theme.dart';
import 'package:buswallet/providers/app_config_provider.dart';
import 'package:buswallet/providers/categories_provider.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  ).then((value) =>runApp(
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
      child: const BusWallet(),
    )
  ));
}
class BusWallet extends StatefulWidget {
  const BusWallet({Key? key}) : super(key: key); 

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buswallet',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: configProvider.themeMode,
      home: const Splash(),
    );
  }
}