import 'package:flutter/material.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/screens/base.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() { 
    super.initState();
    
    _getAllPasses();
  }

  void _getAllPasses() async {
    List<PassFile?> files = await Pass().getAllSaved();
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => Base(passes: files))
    );
  }

  @override
  Widget build(BuildContext context) {
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