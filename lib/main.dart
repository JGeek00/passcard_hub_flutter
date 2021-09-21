import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BusWallet());
}
class BusWallet extends StatelessWidget {
  const BusWallet({Key? key}) : super(key: key); 

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