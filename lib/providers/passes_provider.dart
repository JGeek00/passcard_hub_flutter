import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/models/pass_category.dart';
import 'package:buswallet/utils/dates.dart';

class PassesProvider with ChangeNotifier {
  // Passes
  List<PassFile?> _passes = [];

  List<PassFile?> get getPasses {
    if (_selectedCategory == _categoriesLabels[0]['value']) {
      return [..._passes];
    }
    else if (_selectedCategory == _categoriesLabels[1]['value']) {
      return [..._passes.where((pass) {
        var exists = false;
        for (var category in _categories) {
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
      return [..._passes.where((pass) {
        return pass!.pass.passTypeIdentifier == _selectedCategory;
      }).toList()];
    }
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


  // Categories
  List<PassCategory> _categories = [];
  String _selectedCategory = "all";
  String _categoryTitle = "Todos";
  Database? _dbInstance;

  String listPassesSplitChar = "·";

  static const List<Map<String, dynamic>> _categoriesLabels = [
    {'value': 'all', 'label': 'Todos'},
    {'value': 'not_categorized', 'label': 'Sin categoría'}
  ];

  List<PassCategory> get getCategories {
    return [..._categories];
  }

  String get categorySelected {
    return _selectedCategory;
  }

  String get categoryTitle {
    return _categoryTitle;
  }

  List<Map<String, dynamic>> get categoriesLabels {
    return _categoriesLabels;
  }

  void saveCategories(List<PassCategory> categories) {
    _categories = categories;
    saveMultipleIntoDb(categories);
    notifyListeners();
  }

  void addCategory(PassCategory category) {
    _categories.add(category);
    saveOneIntoDb(category);
    notifyListeners();
  }

  void changeCategorySelected(String? newSelected, String? titleSelected) {
    if (newSelected != null && titleSelected != null) {
      _selectedCategory = newSelected;
      _categoryTitle = titleSelected;
    }
    notifyListeners();
  }

  void selectDefaultCategory() {
    _selectedCategory = _categoriesLabels[0]['value'];
    _categoryTitle = _categoriesLabels[0]['label'];
    notifyListeners();
  }

  void setDbInstance(Database db) {
    _dbInstance = db;
    notifyListeners();
  }

  void saveOneIntoDb(PassCategory category) async {
    String items = "";
    for (var i=0; i<category.items.length; i++) {
      if (i < category.items.length-1) {
        items = items + "${category.items[i]}·";
      }
      else {
        items = items + "${category.items[i]}";
      }
    }
    await _dbInstance!.transaction((txn) async {
      await txn.rawUpdate(
        'INSERT INTO categories (id, name, dateFormat, items) VALUES ("${category.id}", "${category.name}", "${category.dateFormat}", "$items")',
      );
    });
  }

  void saveMultipleIntoDb(List<PassCategory> categories) async {
    await _dbInstance!.transaction((txn) async {
      await txn.rawDelete(
        'DELETE FROM categories',
      );
    });

    for (var category in categories) {
      String items = "";
      for (var i=0; i<category.items.length; i++) {
        if (i < category.items.length-1) {
          items = items + "${category.items[i]}$listPassesSplitChar";
        }
        else {
          items = items + "${category.items[i]}";
        }
      }
      await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'INSERT INTO categories (id, name, dateFormat, items) VALUES ("${category.id}", "${category.name}", "${category.dateFormat}", "$items")',
        );
      });
    }
  }

  void saveFromDb(List<Map<String, Object?>> values) {
    for (var value in values) { 
      _categories.add(
        PassCategory(
          id: value['id'].toString(), 
          name: value['name'].toString(), 
          dateFormat: value['dateFormat'].toString(), 
          items: value['items'].toString().split(listPassesSplitChar),
        ),
      );
    }
  }
}