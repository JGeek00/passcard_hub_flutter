import 'package:passcard_hub/utils/passes.dart';
import 'package:flutter/material.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/utils/loading_modal.dart';
import 'package:passcard_hub/utils/categories.dart';
import 'package:passcard_hub/utils/dates.dart';

class PassesProvider with ChangeNotifier {
  CategoriesProvider? _categoriesProvider;

  List<PassFile?> _passes = [];
  List<String> _archivedPasses = [];

  update(CategoriesProvider? categoriesProvider) {
    if (categoriesProvider != null) {
      _categoriesProvider = categoriesProvider;
    }
  }

  List<PassFile?> get getAllPasses {
    return [..._passes];
  }

  List<PassFile?> get getPasses {
    if (_categoriesProvider!.selectedStatus == 'active') {
      List<PassFile?> activePasses = _passes.where((pass) => !_archivedPasses.contains(pass!.pass.serialNumber)).toList();
      
      if (_categoriesProvider!.categorySelected == _categoriesProvider!.categoriesLabels[0]['value']) {
        return [...activePasses];
      }
      else if (_categoriesProvider!.categorySelected  ==  _categoriesProvider!.categoriesLabels[1]['value']) {
        return [...activePasses.where((pass) {
          var exists = false;
          for (var category in _categoriesProvider!.getCategories) {
            if (category.id == '${pass!.pass.passTypeIdentifier}_${getPassType(pass)}') {
              exists = true;
              break;
            }
          }
          if (exists == false) {
            return true;
          }
          else {
            return false;
          }
        }).toList()];
      }
      else {
        return [...activePasses.where((pass) {
          return '${pass!.pass.passTypeIdentifier}_${getPassType(pass)}' == _categoriesProvider!.categorySelected;
        }).toList()];
      }
    }
    else {
      List<PassFile?> archivedPasses = _passes.where((pass) => _archivedPasses.contains(pass!.pass.serialNumber)).toList();
    
      if (_categoriesProvider!.categorySelected == _categoriesProvider!.categoriesLabels[0]['value']) {
        return [...archivedPasses];
      }
      else if (_categoriesProvider!.categorySelected == _categoriesProvider!.categoriesLabels[1]['value']) {
        return [...archivedPasses.where((pass) {
          var exists = false;
          for (var category in _categoriesProvider!.getCategories) {
            if (category.id == pass!.pass.passTypeIdentifier) {
              exists = true;
              break;
            }
          }
          if (exists == false) {
            return true;
          }
          else {
            return false;
          }
        }).toList()];
      }
      else {
        return [...archivedPasses.where((pass) {
          return pass!.pass.passTypeIdentifier == _categoriesProvider!.categorySelected;
        }).toList()];
      }
    }
  }

  void savePasses(List<PassFile?> inputPasses) {
    var sortedPasses = sortPassDates(
      items: inputPasses,
      categories: _categoriesProvider!.getCategories,
    );
    _passes = sortedPasses;
    notifyListeners();
  } 

  void saveInitialPasses(List<PassFile?> inputPasses) {
    _passes = inputPasses;
    notifyListeners();
  } 

  void sortPasses() {
    var sortedPasses = sortPassDates(
      items: _passes,
      categories: _categoriesProvider!.getCategories,
    );
    _passes = sortedPasses;
  }

  void savePass(PassFile? inputPass) async {
    _passes.add(inputPass);

    String passType = "";
    if (inputPass!.pass.boardingPass != null) {
      passType = "boardingPass";
    }
    else if (inputPass.pass.coupon != null) {
      passType = "coupon";
    }
    else if (inputPass.pass.eventTicket != null) {
      passType = "eventTicket";
    }
    else if (inputPass.pass.generic != null) {
      passType = "generic";
    }

    await _categoriesProvider!.dbInstance!.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO passes (id, type, status) VALUES ("${inputPass.pass.serialNumber}", "$passType", "active")',
      );
    });
    notifyListeners();
  }

  void sortPassesByDate() {
    List<PassFile?> sorted = sortPassDates(
      items: _passes,
      categories: _categoriesProvider!.getCategories,
    );
    _passes = sorted;
    notifyListeners();
  }

  void deletePassOnlyFromStorage(BuildContext context, PassFile inputPass) async {
    showLoadingModal(context);

    List<PassFile> files = await Pass().delete(inputPass);
    _passes = files;

    hideLoadingModal(context);

    notifyListeners();
  }

  void deletePass(BuildContext context, PassFile inputPass) async {
    showLoadingModal(context);

    List<PassFile> files = await Pass().delete(inputPass);
    _passes = files;

    await _categoriesProvider!.dbInstance!.transaction((txn) async {
      await txn.rawDelete(
        'DELETE FROM passes WHERE id = ?',
        [inputPass.pass.serialNumber]
      );
    });

    List<String> newArchived = removePassFromArchive(_archivedPasses, inputPass.pass.serialNumber);
    _archivedPasses = newArchived;

    try {
      final result = removePassFromCategory(_categoriesProvider!.getCategories, inputPass);
      _categoriesProvider!.saveCategories(result['categories']);
      if (result['removedCategory'] == true) {
        _categoriesProvider!.selectDefaultCategory();
      }
    } catch (_) {
    }

    hideLoadingModal(context);

    notifyListeners();
  }

  void changePassStatus(PassFile passFile, String newStatus) async {
    if (newStatus == 'archived') {
      _archivedPasses.add(passFile.pass.serialNumber);
    }
    else if (newStatus == 'active') {
      List<String> newPasses = _archivedPasses.where((passId) => passId != passFile.pass.serialNumber).toList();
      _archivedPasses = newPasses;
    }

    await _categoriesProvider!.dbInstance!.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE PASSES set status = ? WHERE id = ?',
        [newStatus, passFile.pass.serialNumber]
      );
    });

    notifyListeners();
  }

  void setArchivedPasses(List archivedPasses) {
    for (var pass in archivedPasses) {
      _archivedPasses.add(pass['id']);
    }
  }
}