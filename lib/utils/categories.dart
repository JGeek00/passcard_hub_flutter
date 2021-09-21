import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/utils/create_category.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/models/pass_category.dart';

void manageCategories(BuildContext context, PassFile passFile) {
  final categoriesProvider = Provider.of<PassesProvider>(context, listen: false);
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
    createCategory(context, passFile);
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

void createCategory(BuildContext context, PassFile passFile) {
  openFieldsDialog(context, passFile);
}

List<Map<String, dynamic>> getPassFields(PassFile passFile) {
  List<Map<String, dynamic>> fields = [];

  if (passFile.pass.boardingPass!.headerFields != null) {
    var setFields = passFile.pass.boardingPass!.headerFields;
    for (var i = 0; i < setFields!.length; i++) {
      fields.add({
        'key': setFields[i].key,
        'label': setFields[i].label,
        'value': setFields[i].value,
        'path': 'headerFields',
        'index': i,
      });
    }
  }

  if (passFile.pass.boardingPass!.primaryFields != null) {
    var setFields = passFile.pass.boardingPass!.primaryFields;
    for (var i = 0; i < setFields!.length; i++) {
      if (setFields[i].value != '') {
        fields.add({
          'key': setFields[i].key,
          'label': setFields[i].label,
          'value': setFields[i].value,
          'path': 'primaryFields',
          'index': i,
        });
      }
    }
  }

  if (passFile.pass.boardingPass!.auxiliaryFields != null) {
    var setFields = passFile.pass.boardingPass!.auxiliaryFields;
    for (var i = 0; i < setFields!.length; i++) {
      if (setFields[i].value != '') {
        fields.add({
          'key': setFields[i].key,
          'label': setFields[i].label,
          'value': setFields[i].value,
          'path': 'auxiliaryFields',
          'index': i,
        });
      }
    }
  }

  if (passFile.pass.boardingPass!.secondaryFields != null) {
    var setFields = passFile.pass.boardingPass!.secondaryFields;
    for (var i = 0; i < setFields!.length; i++) {
      if (setFields[i].value != '') {
        fields.add({
          'key': setFields[i].key,
          'label': setFields[i].label,
          'value': setFields[i].value,
          'path': 'secondaryFields',
          'index': i,
        });
      }
    }
  }

  return fields;
}