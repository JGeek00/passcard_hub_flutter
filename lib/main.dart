import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BusWallet());
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PassesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buswallet',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          fontFamily: 'ProductSans',
        ),
        home: const Splash(),
      ),
    );
  }
}