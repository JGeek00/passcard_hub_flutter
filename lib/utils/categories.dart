import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/utils/passes.dart';
import 'package:passcard_hub/widgets/page_dialog_add_dateformat_category.dart';
import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/utils/create_category.dart';
import 'package:passcard_hub/models/pass_category.dart';

void showCategoryDialog(BuildContext context, String categoryId, PassFile file) {
  showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context, 
    builder: (context) => DialogAddDateFormatCategory(
      accept: () {
        Navigator.of(context).pop();
        addDateFormatCategory(context, categoryId, file);
      }, 
      cancel: () {
        Navigator.of(context).pop();
      }
    ),
  );
}

Map<String, dynamic>? manageCategories(BuildContext context, PassFile passFile, List<PassCategory>? addedCategories) {
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
  
  List<PassCategory> categories = categoriesProvider.getCategories;

  PassCategory? exists;

  for (var category in categories) {
    if (category.id == getPassTypeIdentifier(passFile)) {
      exists = category;
    }
  }

  if (addedCategories != null) {
    for (var category in addedCategories) {
      if (category.id == getPassTypeIdentifier(passFile)) {
        exists = category;
      }
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
    PassCategory category = PassCategory(
      id: getPassTypeIdentifier(passFile), 
      name: passFile.pass.organizationName, 
      type: getPassType(passFile),
      dateFormat: "",
      path: "",
      index: null,
      items: [
        passFile.pass.serialNumber.toString()
      ]
    );

    categoriesProvider.addCategory(category);

    if (addedCategories != null) {
      addedCategories.add(category);
    }

    if (passFile.pass.boardingPass != null) {
      return {'category': category.id, 'file': passFile};
    }
  }
}

Map<String, dynamic> removePassFromCategory(List<PassCategory> categories, PassFile passFile) {
  final category = categories.firstWhere((category) {
    return category.id == getPassTypeIdentifier(passFile);
  });

  if (category.items.length < 2) {
    List<PassCategory> newCategories = [...categories];
    newCategories.removeWhere((category) => category.id == getPassTypeIdentifier(passFile));

    return {
      'categories': newCategories,
      'removedCategory': true,
    };
  }
  else {
    List<PassCategory> newCategories = [];
    for (var category in categories) {
      if (category.id != getPassTypeIdentifier(passFile)) {
        newCategories.add(category);
      }
      else {
        List newItems = [...category.items];
        newItems.removeWhere((item) => item == passFile.pass.serialNumber.toString());

        PassCategory newCategory = PassCategory(
          id: category.id, 
          name: category.name, 
          type: category.type,
          dateFormat: category.dateFormat, 
          path: category.path,
          index: category.index,
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

void addDateFormatCategory(BuildContext context, String categoryId, PassFile passFile) {
  openFieldsDialog(context, categoryId, passFile);
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