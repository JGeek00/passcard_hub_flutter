import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:passcard_hub/widgets/loading_modal.dart';
import 'package:passcard_hub/models/pass_category.dart';
import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/utils/loading_modal.dart';
import 'package:passcard_hub/providers/passes_provider.dart';
import 'package:passcard_hub/utils/categories.dart';


Future<Map<String, dynamic>> pickFiles({
  required BuildContext context, 
}) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  void showLoadingModal() {
    showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: context, 
      builder: (context) {
        return const LoadingModal();
      }
    );
  }

  List<PassCategory> addedCategories = [];
  List newCategories = [];

  Future<int> manageNewFile(PlatformFile inFile) async {
    if (inFile.extension == 'pkpass') {

      File file = File(inFile.path!);
      PassFile passFile = await Pass().saveFromFile(file: file);

      final exists = checkPassExists(passesProvider.getAllPasses, passFile);

      if (exists == false) {
        await passesProvider.savePass(passFile);

        Map<String, dynamic>? newCategoryData = manageCategories(context, passFile, addedCategories);

        if (newCategoryData!= null) {
          newCategories.add(newCategoryData);
        }

        categoriesProvider.selectDefaultCategory();

        passesProvider.sortPassesByDate();
                
        return 0;
      }
      else {
        await passesProvider.deletePassOnlyFromStorage(context, passFile);

        passesProvider.sortPassesByDate();

        return 1;
      }
    }
    else {
      return 2;
    }
  }

  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: AppLocalizations.of(context)!.selectPkpass,
      allowMultiple: true,
    );

    showLoadingModal();

    if (result != null) {
      if (result.files.length < 2) {
        int code = await manageNewFile(result.files[0]);

        hideLoadingModal(context);

        for (var newCategory in newCategories) {
          showCategoryDialog(
            context, 
            newCategory['category'], 
            newCategory['file'],
          );
        }

        switch (code) {
          case 0:
            return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.passSaved, 'color': Colors.green};
            
          case 1:
            return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.existingPass, 'color': Colors.red};
         
          case 2:
            return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.filePickerCancelled, 'color': Colors.red};
           
          default:
            return {};
        }        
      }
      else {
        int fileOk = 0;
        int fileExists = 0;
        int fileNotValid = 0;

        for (var file in result.files) {
          int code = await manageNewFile(file);
          switch (code) {
            case 0:
              fileOk = fileOk + 1;
              break;
              
            case 1:
              fileExists = fileExists + 1;
              break;

            case 2:
              fileNotValid = fileNotValid + 1;
              break;

            default:
              break;
          }
        }
        
        hideLoadingModal(context);

        for (var newCategory in newCategories) {
          showCategoryDialog(
            context, 
            newCategory['category'], 
            newCategory['file'],
          );
        }

        return {'type': 'modal', 'results': {
          'fileOk': fileOk, 
          'fileExists': fileExists, 
          'fileNotValid': fileNotValid
        }};
      }
    } else {
      hideLoadingModal(context);
      return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.filePickerCancelled, 'color': Colors.red};
    }
  } catch (e) {
    if (e.toString().contains('read_external_storage_denied')) {
      hideLoadingModal(context);
      return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.storagePermissionDenied, 'color': Colors.red};
    }
    else {
      hideLoadingModal(context);
      return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.unknownError, 'color': Colors.red};
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

  List<PassCategory> addedCategories = [];
  List newCategories = [];

  try {
    PassFile passFile = await Pass().saveFromUrl(url: url);

    final exists = checkPassExists(passesProvider.getPasses, passFile);

    if (exists == false) {
      passesProvider.savePass(passFile);

      hideLoadingModal(context);

      Map<String, dynamic>? newCategoryData = manageCategories(context, passFile, addedCategories);

      if (newCategoryData!= null) {
        newCategories.add(newCategoryData);
      }

      for (var newCategory in newCategories) {
        showCategoryDialog(
          context, 
          newCategory['category'], 
          newCategory['file'],
        );
      }

      categoriesProvider.selectDefaultCategory();

      if (newCategories.isEmpty) {
        passesProvider.sortPassesByDate();
      }
                  
      return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.passSaved, 'color': Colors.green};
    }
    else {
      await passesProvider.deletePassOnlyFromStorage(context, passFile);

      passesProvider.sortPassesByDate();

      hideLoadingModal(context);

      return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.existingPass, 'color': Colors.red};
    }
  } catch (e) {
    hideLoadingModal(context);

    return {'type': 'snackbar', 'message': AppLocalizations.of(context)!.urlNotValid, 'color': Colors.red};
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

String getPassType(PassFile passFile) {
  if (passFile.pass.boardingPass != null) {
    return "transport";
  }
  else if (passFile.pass.coupon != null) {
    return "coupon";
  }
  else if (passFile.pass.eventTicket != null) {
    return "eventTicket";
  }
  else if (passFile.pass.generic != null) {
    return "generic";
  }
  else {
    return "";
  }
}

String getPassTypeIdentifier(PassFile passFile) {
  return '${passFile.pass.passTypeIdentifier}_${getPassType(passFile)}';
}