import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/utils/loading_modal.dart';
import 'package:passcard_hub/providers/passes_provider.dart';
import 'package:passcard_hub/utils/categories.dart';
import 'package:pass_flutter/pass_flutter.dart';


Future<Map<String, dynamic>> pickFiles({
  required BuildContext context, 
}) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Selecciona un fichero .pkpass"
    );
    if (result != null) {
      if (result.files.single.extension == 'pkpass') {
        showLoadingModal(context);

        File file = File(result.files.single.path!);
        PassFile passFile = await Pass().saveFromFile(file: file);

        final exists = checkPassExists(passesProvider.getAllPasses, passFile);

        if (exists == false) {
          
          if (passFile.pass.boardingPass != null) {
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

            return {'message': "Este tipo de pase aún no está soportado", 'color': Colors.red};
          }
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
      return {'message': "Selección de fichero cancelada", 'color': Colors.red};
    }
  } catch (e) {
    if (e.toString().contains('read_external_storage_denied')) {
      return {'message': "Permiso de acceso al almacenamiento denegado", 'color': Colors.red};
    }
    else {
      return {'message': "Error desconocido", 'color': Colors.red};
    }
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