import 'package:flutter/material.dart';
import 'package:pass_flutter/pass_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:barcode_widget/barcode_widget.dart';
// ignore: implementation_imports
import 'package:barcode/src/barcode.dart' as barcode;

Widget getPassCode(BuildContext context, String type, PassFile passFile, String container) {
  double size = 0;
  if (container == "card") {
    print(MediaQuery.of(context).size.height);
    size = MediaQuery.of(context).size.height < 770 ? 150 : 200;
  }
  else if (container == "modal") {
    size = 280;
  }

  switch (type) {
    case 'PKBarcodeFormatQR':
      return Container(
        height: size,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: QrImage(
          data: passFile.pass.barcode!.message,
          version: QrVersions.auto,
          gapless: true,
        ),
      );

    case 'PKBarcodeFormatCode128': 
      return BarcodeWidget(
        barcode: barcode.Barcode.code128(),
        data: passFile.pass.barcode!.message,
        padding: const EdgeInsets.all(20),
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        style: const TextStyle(
          color: Colors.black
        ),
      );

    case 'PKBarcodeFormatPDF417': 
      return BarcodeWidget(
        barcode: barcode.Barcode.pdf417(),
        data: passFile.pass.barcode!.message,
        padding: const EdgeInsets.all(20),
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        style: const TextStyle(
          color: Colors.black
        ),
      );

    case 'PKBarcodeFormatAztec': 
      return BarcodeWidget(
        barcode: barcode.Barcode.aztec(),
        data: passFile.pass.barcode!.message,
        padding: const EdgeInsets.all(20),
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        style: const TextStyle(
          color: Colors.black
        ),
      );
        
    default:
      return const SizedBox();
  }
}