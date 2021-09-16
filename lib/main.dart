import 'package:buswallet/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BusWallet());
}

class BusWallet extends StatelessWidget {
  const BusWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buswallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ProductSans',
      ),
      home: const Home(),
    );
  }
}