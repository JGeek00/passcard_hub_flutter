import 'package:passcard_hub/utils/pass_code.dart';
import 'package:passcard_hub/widgets/code_modal.dart';
import 'package:flutter/material.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/widgets/card_row.dart';



class CardWidget extends StatelessWidget {
  final PassFile? passFile;
  final bool loading;

  const CardWidget({
    Key? key, 
    required this.passFile,
    required this.loading,
  }) : super(key: key);

  void _openCodeDialog(BuildContext context, String codeType, PassFile passFile) {
    showDialog(
      context: context, 
      builder: (context) => CodeModal(codeType: codeType, passFile: passFile),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pass;
    if (passFile!.pass.boardingPass != null) {
      pass = passFile!.pass.boardingPass;
    }
    else if (passFile!.pass.coupon != null) {
      pass = passFile!.pass.coupon;
    }
    else if (passFile!.pass.eventTicket != null) {
      pass = passFile!.pass.eventTicket;
    }
    else if (passFile!.pass.generic != null) {
      pass = passFile!.pass.generic;
    }

    return Column(
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
              child: loading == true ? const Center(
                child: CircularProgressIndicator(),
              ) : Wrap(
                runSpacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                children: [ 
                  if (pass.headerFields != null) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (passFile != null && passFile?.logo != null) SizedBox(
                        height: 30,
                        child: Image.file(passFile!.logo!.image!),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pass.headerFields![0].label}',
                            style: TextStyle(
                              color: passFile!.pass.labelColor,
                            ),
                          ),
                          Text(
                            '${pass.headerFields![0].value}',
                            style: TextStyle(
                              color: passFile!.pass.foregroundColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (pass.primaryFields != null) CardRow(
                    items: pass.primaryFields!, 
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  if (pass.auxiliaryFields != null) CardRow(
                    items: pass.auxiliaryFields!,
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  if (pass.secondaryFields != null) CardRow(
                    items: pass.secondaryFields!,
                    labelColor: passFile!.pass.labelColor,
                    valueColor: passFile!.pass.foregroundColor,
                  ),
                  if (passFile!.pass.barcode != null) GestureDetector(
                    onTap: () => _openCodeDialog(context, passFile!.pass.barcode!.format, passFile!),
                    child: Center(
                      child: getPassCode(context, passFile!.pass.barcode!.format, passFile!, 'card'),
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