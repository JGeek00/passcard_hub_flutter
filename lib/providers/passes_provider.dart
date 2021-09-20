import 'package:buswallet/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:pass_flutter/pass_flutter.dart';

class PassesProvider with ChangeNotifier {
  List<PassFile?> _passes = [];

  List<PassFile?> get getPasses {
    return [..._passes];
  }

  void savePasses(List<PassFile?> inputPasses) {
    var sortedPasses = sortPassDates(
      items: inputPasses, 
      field: 'auxiliaryFields', 
      index: 0
    );
    _passes = sortedPasses;
    notifyListeners();
  } 

  void savePass(PassFile? inputPass) {
    _passes.add(inputPass);
    notifyListeners();
  }
  
  void saveAndSort({
    required PassFile? inputPass, 
    required String field, 
    required int index
  }) {
    savePass(inputPass);
    sortPassesByDate(field: field, index: index);
    notifyListeners();
  }

  void sortPassesByDate({
    required field, 
    required index
  }) {
    List<PassFile?> sorted = sortPassDates(items: _passes, field: field, index: index);
    _passes = sorted;
    notifyListeners();
  }

  void deletePass(PassFile inputPass) async {
    List<PassFile> files = await Pass().delete(inputPass);
    _passes = files;
    notifyListeners();
  }
}