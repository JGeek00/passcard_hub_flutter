import 'package:flutter/material.dart';

import 'package:buswallet/models/pass_category.dart';

class CategoriesProvider with ChangeNotifier {
  List<PassCategory> _categories = [];

  List<PassCategory> get getCategories {
    return [..._categories];
  }

  void saveCategories(List<PassCategory> categories) {
    _categories = categories;
    notifyListeners();
  }

  void addCategory(PassCategory category) {
    _categories.add(category);
    notifyListeners();
  }
}