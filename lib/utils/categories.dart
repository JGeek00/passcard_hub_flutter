import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/models/pass_category.dart';

void manageCategories(categoriesProvider, PassFile passFile) {
  List<PassCategory> categories = categoriesProvider.getCategories;
  
  PassCategory? exists;
  for (var category in categories) {
    if (category.id == passFile.pass.passTypeIdentifier) {
      exists = category;
    }
  }
     
  if (exists != null) {
    exists.items.add(passFile.pass.serialNumber.toString());
     
    List<PassCategory> newCategories = categories.map((category) {
      if (category.id == exists!.id) {
        return exists;
      }
      else {
        return category;
      }
    }).toList();
  
    categoriesProvider.saveCategories(newCategories);
  }
  else {
    categoriesProvider.addCategory(
      PassCategory(
        id: passFile.pass.passTypeIdentifier, 
        name: passFile.pass.organizationName, 
        dateFormat: "dd-MM-yyyy HH:mm",
        items: [
          passFile.pass.serialNumber.toString()
        ]
      ),
    );
  }
}

Map<String, dynamic> removePassFromCategory(List<PassCategory> categories, PassFile passFile) {
  final category = categories.firstWhere((category) => category.id == passFile.pass.passTypeIdentifier);
  if (category.items.length < 2) {
    List<PassCategory> newCategories = [...categories];
    newCategories.removeWhere((category) => category.id == passFile.pass.passTypeIdentifier);
    return {
      'categories': newCategories,
      'removedCategory': true,
    };
  }
  else {
    List<PassCategory> newCategories = [];
    for (var category in categories) {
      if (category.id != passFile.pass.passTypeIdentifier) {
        newCategories.add(category);
      }
      else {
        List newItems = [...category.items];
        newItems.removeWhere((item) => item == passFile.pass.serialNumber.toString());

        PassCategory newCategory = PassCategory(
          id: category.id, 
          name: category.name, 
          dateFormat: category.dateFormat, 
          items: newItems
        );

        newCategories.add(newCategory);
      }
    }

    return {
      'categories': newCategories,
      'removedCategory': false,
    };
  }
}