import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      dialogTitle: AppLocalizations.of(context)!.selectPkpass
    );
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
                
          return {'message': AppLocalizations.of(context)!.passSaved, 'color': Colors.green};
        }
        else {
          await passesProvider.deletePassOnlyFromStorage(context, passFile);

          passesProvider.sortPassesByDate();

          hideLoadingModal(context);

          return {'message': AppLocalizations.of(context)!.existingPass, 'color': Colors.red};
        }
      }
      else {
        return {'message': AppLocalizations.of(context)!.notPkpass, 'color': Colors.red};
      }
    } else {
      return {'message': AppLocalizations.of(context)!.filePickerCancelled, 'color': Colors.red};
    }
  } catch (e) {
    if (e.toString().contains('read_external_storage_denied')) {
      hideLoadingModal(context);
      return {'message': AppLocalizations.of(context)!.storagePermissionDenied, 'color': Colors.red};
    }
    else {
      hideLoadingModal(context);
      return {'message': AppLocalizations.of(context)!.unknownError, 'color': Colors.red};
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

  try {
    PassFile passFile = await Pass().saveFromUrl(url: url);

    final exists = checkPassExists(passesProvider.getPasses, passFile);

    if (exists == false) {
      passesProvider.savePass(passFile);

      hideLoadingModal(context);

      manageCategories(context, passFile);

      categoriesProvider.selectDefaultCategory();

      passesProvider.sortPassesByDate();
                  
      return {'message': AppLocalizations.of(context)!.passSaved, 'color': Colors.green};
    }
    else {
      passesProvider.deletePassOnlyFromStorage(context, passFile);

      passesProvider.sortPassesByDate();

      hideLoadingModal(context);

      return {'message': AppLocalizations.of(context)!.existingPass, 'color': Colors.red};
    }
  } catch (e) {
    hideLoadingModal(context);

    return {'message': AppLocalizations.of(context)!.urlNotValid, 'color': Colors.red};
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