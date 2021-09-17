import 'package:flutter/material.dart';

import 'package:buswallet/pages/base.dart';

void main() {
  runApp(const BusWallet());
}
class BusWallet extends StatelessWidget {
  const BusWallet({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buswallet',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'ProductSans',
      ),
      home: const Base()
    );
  }
}