import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/screens/base.dart';
import 'package:buswallet/providers/passes_provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void _getAllPasses(void Function(List<PassFile?> savePasses) savePasses) async {
    List<PassFile?> files = await Pass().getAllSaved();
    savePasses(files);
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => Base())
    );
  }

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context, listen: false);

    _getAllPasses(passesProvider.savePasses);

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