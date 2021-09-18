import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/card_row.dart';


class CardWidget extends StatelessWidget {
  final PassFile? passFile;

  const CardWidget({
    Key? key, 
    required this.passFile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.all(20),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: passFile!.pass.backgroundColor
              ),
              child: Wrap(
                runSpacing: 40,
                children: [ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (passFile != null && passFile?.logo != null) Container(
                        height: 30,
                        child: Image.file(passFile!.logo!.image!),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${passFile?.pass.boardingPass?.headerFields![0].label}',
                            style: TextStyle(
                              color: passFile!.pass.labelColor,
                            ),
                          ),
                          Text(
                            '${passFile?.pass.boardingPass?.headerFields![0].value}',
                            style: TextStyle(
                              color: passFile!.pass.foregroundColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  CardRow(
                    items: passFile!.pass.boardingPass!.primaryFields!, 
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  CardRow(
                    items: passFile!.pass.boardingPass!.auxiliaryFields!,
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  CardRow(
                    items: passFile!.pass.boardingPass!.secondaryFields!,
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  if (passFile!.pass.barcode != null) Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: QrImage(
                        data: passFile!.pass.barcode!.message,
                        version: QrVersions.auto,
                        gapless: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}