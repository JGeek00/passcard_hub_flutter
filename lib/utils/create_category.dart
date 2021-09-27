import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passhub/providers/passes_provider.dart';
import 'package:passhub/providers/categories_provider.dart';
import 'package:passhub/widgets/create_category_assistant.dart';
import 'package:passhub/models/pass_category.dart';
import 'package:passhub/utils/categories.dart';


String? selectedField;
String? selectedPath;
int? selectedIndex;

int page = 1;


String getDateValue(PassFile passFile, String inputSelectedPath, int inputSelectedIndex) {
  selectedPath = inputSelectedPath;
  selectedIndex = inputSelectedIndex;
  return passFile.pass.boardingPass![DynamicAccess(field: inputSelectedPath, index: inputSelectedIndex)]!;
}

void saveCategory(BuildContext context, PassFile passFile, String datePattern) {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  Navigator.of(context).pop();
  categoriesProvider.addCategory(
    PassCategory(
      id: passFile.pass.passTypeIdentifier, 
      name: passFile.pass.organizationName, 
      dateFormat: datePattern,
      path: selectedPath,
      index: selectedIndex,
      items: [
        passFile.pass.serialNumber.toString()
      ]
    ),
  );

  passesProvider.sortPassesByDate();
}

void openFieldsDialog(BuildContext context, PassFile passFile) {
  List<Map<String, dynamic>> fields = getPassFields(passFile);
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (context) => CreateCategoryAssistant(
      passFile: passFile,
      fields: fields, 
    ),
  );
}