import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/providers/categories_provider.dart';
import 'package:buswallet/utils/loading_modal.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/utils/categories.dart';
import 'package:pass_flutter/pass_flutter.dart';


Future<Map<String, dynamic>> pickFiles({
  required BuildContext context, 
}) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    if (result.files.single.extension == 'pkpass') {
      showLoadingModal(context);

      File file = File(result.files.single.path!);
      PassFile passFile = await Pass().saveFromFile(file: file);

      final exists = checkPassExists(passesProvider.getAllPasses, passFile);

      if (exists == false) {
        passesProvider.savePass(passFile);

        hideLoadingModal(context);

        manageCategories(context, passFile);

        categoriesProvider.selectDefaultCategory();

        passesProvider.sortPassesByDate();
            
        return {'message': "Pase guardado correctamente", 'color': Colors.green};
      }
      else {
        passesProvider.deletePassOnlyFromStorage(context, passFile);

        passesProvider.sortPassesByDate();

        hideLoadingModal(context);

        return {'message': "El pase no ha sido guardado porque ya existía", 'color': Colors.red};
      }
    }
    else {
      return {'message': "El fichero seleccionado no es un pkpass.", 'color': Colors.red};
    }
  } else {
    hideLoadingModal(context);

    return {'message': "Selección de fichero cancelada", 'color': Colors.red};
  }
}

Future<Map<String, dynamic>> downloadFromUrl({
  required BuildContext context, 
  required String url
}) async {
  showLoadingModal(context);

  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  PassFile passFile = await Pass().saveFromUrl(url: url);

  final exists = checkPassExists(passesProvider.getPasses, passFile);

  if (exists == false) {
    passesProvider.savePass(passFile);

    manageCategories(context, passFile);

    categoriesProvider.selectDefaultCategory();

    passesProvider.sortPassesByDate();

    hideLoadingModal(context);
        
    return {'message': "Pase guardado correctamente", 'color': Colors.green};
  }
  else {
    passesProvider.deletePassOnlyFromStorage(context, passFile);

    hideLoadingModal(context);

    return {'message': "El pase no ha sido guardado porque ya existía", 'color': Colors.red};
  }
}

bool checkPassExists(List<PassFile?> passes, PassFile passFile) {
  bool passExists = false;
  for (var pass in passes) {
    if (pass!.pass.serialNumber == passFile.pass.serialNumber) {
      passExists = true;
      break;
    }
  }
  
  return passExists;
}

List<String> removePassFromArchive(List<String> archiveList, String passId) {
  return archiveList.where((pass) => pass != passId).toList();
}