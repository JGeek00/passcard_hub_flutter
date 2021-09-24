import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:buswallet/models/pass_category.dart';


class CategoriesProvider with ChangeNotifier {
  // Categories
  List<PassCategory> _categories = [];
  String _selectedCategory = "all";
  String _categoryTitle = "Todos";
  Database? _dbInstance;
  String _selectedStatus = 'active';

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

  Database? get dbInstance {
    return _dbInstance;
  }

  String get selectedStatus {
    return _selectedStatus;
  }

  void updateSelectedStatus(String newStatus) {
   _selectedStatus = newStatus;
    notifyListeners();
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

    _selectedStatus = 'active';

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
        'INSERT INTO categories (id, name, dateFormat, path, pathIndex, items) VALUES ("${category.id}", "${category.name}", "${category.dateFormat}", "${category.path}", ${category.index}, "$items")',
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
          'INSERT INTO categories (id, name, dateFormat, path, pathIndex, items) VALUES ("${category.id}", "${category.name}", "${category.dateFormat}", "${category.path}", ${category.index}, "$items")',
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
          path: value['path'].toString(),
          index: int.parse(value['pathIndex'].toString()),
          items: value['items'].toString().split(listPassesSplitChar),
        ),
      );
    }
  }
}