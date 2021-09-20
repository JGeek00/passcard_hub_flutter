import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/utils/categories.dart';
import 'package:pass_flutter/pass_flutter.dart';

Future<Map<String, dynamic>> pickFiles({
  required BuildContext context, 
}) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);

  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if(result != null) {
    File file = File(result.files.single.path!);
    PassFile passFile = await Pass().saveFromFile(file: file);

    bool passExists = false;
    for (var pass in passesProvider.getPasses) {
      if (pass!.pass.serialNumber == passFile.pass.serialNumber) {
        passExists = true;
        break;
      }
    }

    if (passExists == false) {
      passesProvider.saveAndSort(
        inputPass: passFile, 
        field: 'auxiliaryFields', 
        index: 0
      );

      manageCategories(passesProvider, passFile);

      passesProvider.selectDefaultCategory();
        
      return {'message': "Pase guardado correctamente", 'color': Colors.green};
      
    }
    else {
      passesProvider.deletePass(passFile);

      return {'message': "El pase no ha sido guardado porque ya existía", 'color': Colors.red};
    }
    
    // try {
    //   DateTime date = DateFormat('dd-MM-yyyy HH-mm').parse(passFile.pass.boardingPass!.auxiliaryFields![0].value!);
    //   print(date);
    // } catch (e) {
    //   print(e);
    // }
      
   
  } else {
    return {'message': "Selección de fichero cancelada", 'color': Colors.red};
  }
}

Future<Map<String, dynamic>> downloadFromUrl({
  required BuildContext context, 
  required String url
}) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);

  PassFile passFile = await Pass().saveFromUrl(url: url);

  passesProvider.savePass(passFile);

  return {'message': "Pase guardado correctamente", 'color': Colors.green};
}