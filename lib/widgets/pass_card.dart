import 'dart:io';
import 'dart:ui';

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
    PassStructureDictionary? pass;
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

    File? backgroundImage;
    if (passFile!.background != null) {
      if (passFile!.background!.image3x != null) {
        backgroundImage = passFile!.background!.image3x;
      }
      else if (passFile!.background!.image2x != null) {
        backgroundImage = passFile!.background!.image2x;
      }
      else {
        backgroundImage = passFile!.background!.image;
      }
    }

    File? thumbnailImage;
    if (passFile!.thumbnail != null) {
      if (passFile!.thumbnail!.image3x != null) {
        thumbnailImage = passFile!.thumbnail!.image3x;
      }
      else if (passFile!.thumbnail!.image2x != null) {
        thumbnailImage = passFile!.thumbnail!.image2x;
      }
      else {
        thumbnailImage = passFile!.thumbnail!.image;
      }
    }

    if (passFile!.pass.boardingPass != null) {
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: passFile!.pass.backgroundColor,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: loading == true ? const Center(
                    child: CircularProgressIndicator(),
                  ) : Wrap(
                    runSpacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                    children: [ 
                      Row(
                        mainAxisAlignment: pass!.headerFields != null
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                        children: [
                          if (passFile != null && passFile?.logo != null) SizedBox(
                            height: pass.headerFields == null ? 80 : 30,
                            child: Image.file(passFile!.logo!.image!),
                          ),
                          if (pass.headerFields != null) Column(
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
            ),
          )
        ],
      );
    }
    else if (passFile!.pass.eventTicket != null) {
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: passFile!.pass.backgroundColor,
                  image: backgroundImage != null ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      passFile!.background!.image!
                    )
                  ) : null
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: backgroundImage != null 
                      ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) 
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                      child: loading == true ? const Center(
                        child: CircularProgressIndicator(),
                      ) : Wrap(
                        runSpacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                        children: [ 
                          Row(
                            mainAxisAlignment: pass!.headerFields != null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                            children: [
                              if (passFile != null && passFile?.logo != null) SizedBox(
                                height: pass.headerFields == null ? 
                                  (MediaQuery.of(context).size.height < 770 ? 40 : 50)
                                  : 30,
                                child: Image.file(passFile!.logo!.image!),
                              ),
                              if (pass.headerFields != null) Column(
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
                          if (thumbnailImage != null) Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    spacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                                    direction: Axis.vertical,
                                    children: [
                                      if (pass.primaryFields != null) CardRow(
                                        items: pass.primaryFields!, 
                                        labelColor: passFile!.pass.labelColor,
                                        valueColor: passFile!.pass.foregroundColor,
                                        valueSize: 20,
                                      ),
                                      if (pass.secondaryFields != null) CardRow(
                                        items: pass.secondaryFields!,
                                        labelColor: passFile!.pass.labelColor,
                                        valueColor: passFile!.pass.foregroundColor,
                                        valueSize: 20,
                                      ),
                                    ],
                                  ),
                                  Image.file(
                                    thumbnailImage,
                                    width: 60,
                                  ),
                                ],
                              ),
                              if (pass.auxiliaryFields != null) Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CardRow(
                                  items: pass.auxiliaryFields!,
                                  labelColor: passFile!.pass.labelColor,
                                  valueColor: passFile!.pass.foregroundColor,
                                  valueSize: 20,
                                  valueBold: true,
                                ),
                              )
                            ],
                          ),
                          if (thumbnailImage == null) Wrap(
                            spacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                            direction: Axis.vertical,
                            children: [
                              if (pass.primaryFields != null) CardRow(
                                items: pass.primaryFields!, 
                                labelColor: passFile!.pass.labelColor,
                                valueColor: passFile!.pass.foregroundColor,
                                valueSize: 20,
                                valueBold: true,
                              ),
                              if (pass.secondaryFields != null) CardRow(
                                items: pass.secondaryFields!,
                                labelColor: passFile!.pass.labelColor,
                                valueColor: passFile!.pass.foregroundColor,
                              ),
                              if (pass.auxiliaryFields != null) CardRow(
                                items: pass.auxiliaryFields!,
                                labelColor: passFile!.pass.labelColor,
                                valueColor: passFile!.pass.foregroundColor,
                              ),
                            ],
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
                ),
              ),
            ),
          )
        ],
      );
    }
    else if (passFile!.pass.coupon != null) {
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
                  color: passFile!.pass.backgroundColor,
                  image: backgroundImage != null ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      passFile!.background!.image!
                    )
                  ) : null
                ),
                child: loading == true ? const Center(
                  child: CircularProgressIndicator(),
                ) : Wrap(
                  runSpacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                  children: [ 
                    Row(
                      mainAxisAlignment: pass!.headerFields != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                      children: [
                        if (passFile != null && passFile?.logo != null) SizedBox(
                          height: pass.headerFields == null ? 
                            (MediaQuery.of(context).size.height < 770 ? 40 : 50)
                            : 30,
                          child: Image.file(passFile!.logo!.image!),
                        ),
                        if (pass.headerFields != null) Column(
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
                      labelSize: 20,
                      valueSize: 45,
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
    else if (passFile!.pass.generic != null) {
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
                  color: passFile!.pass.backgroundColor,
                  image: backgroundImage != null ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      passFile!.background!.image!
                    )
                  ) : null,
                ),
                child: loading == true ? const Center(
                  child: CircularProgressIndicator(),
                ) : Wrap(
                  runSpacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                  children: [ 
                    Row(
                      mainAxisAlignment: pass!.headerFields != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                      children: [
                        if (passFile != null && passFile?.logo != null) SizedBox(
                          height: pass.headerFields == null ? 
                            (MediaQuery.of(context).size.height < 770 ? 40 : 50)
                            : 30,
                          child: Image.file(passFile!.logo!.image!),
                        ),
                        if (pass.headerFields != null) Column(
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
                    if (thumbnailImage != null) Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: MediaQuery.of(context).size.height < 770 ? 20 : 30,
                              direction: Axis.vertical,
                              children: [
                                if (pass.primaryFields != null) CardRow(
                                  items: pass.primaryFields!, 
                                  labelColor: passFile!.pass.labelColor,
                                  valueColor: passFile!.pass.foregroundColor,
                                  valueSize: 20,
                                ),
                              ],
                            ),
                            Image.file(
                              thumbnailImage,
                              width: 60,
                            ),
                          ],
                        ),
                        if (pass.secondaryFields != null) CardRow(
                          items: pass.secondaryFields!,
                          labelColor: passFile!.pass.labelColor,
                          valueColor: passFile!.pass.foregroundColor,
                        ),
                        if (pass.auxiliaryFields != null) Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CardRow(
                            items: pass.auxiliaryFields!,
                            labelColor: passFile!.pass.labelColor,
                            valueColor: passFile!.pass.foregroundColor,
                          ),
                        )
                      ],
                    ),
                    if (thumbnailImage == null) Column(
                      children: [
                        if (pass.primaryFields != null) CardRow(
                          items: pass.primaryFields!, 
                          labelColor: passFile!.pass.labelColor,
                          valueColor: passFile!.pass.foregroundColor,
                          valueSize: 20,
                        ),
                        const SizedBox(height: 20),
                        if (pass.secondaryFields != null) CardRow(
                          items: pass.secondaryFields!,
                          labelColor: passFile!.pass.labelColor,
                          valueColor: passFile!.pass.foregroundColor,
                        ),
                        if (pass.auxiliaryFields != null) Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CardRow(
                            items: pass.auxiliaryFields!,
                            labelColor: passFile!.pass.labelColor,
                            valueColor: passFile!.pass.foregroundColor,
                          ),
                        )
                      ],
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
    else {
      return Container();
    }
  }
}