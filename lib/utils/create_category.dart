import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/providers/passes_provider.dart';
import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/widgets/add_dateformat_assistant.dart';
import 'package:passcard_hub/utils/categories.dart';


String? selectedField;
String? selectedPath;
int? selectedIndex;

int page = 1;


String getDateValue(PassFile passFile, String inputSelectedPath, int inputSelectedIndex) {
  selectedPath = inputSelectedPath;
  selectedIndex = inputSelectedIndex;
  return passFile.pass.boardingPass![DynamicAccess(field: inputSelectedPath, index: inputSelectedIndex)]!;
}

void saveDateFormat(BuildContext context, String categoryId, PassFile passFile, String datePattern) async {
  final passesProvider = Provider.of<PassesProvider>(context, listen: false);
  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

  Navigator.of(context).pop();

  await categoriesProvider.editCategoryDateFormat(categoryId, datePattern, selectedPath!, selectedIndex!);

  passesProvider.sortPassesByDate();
}

void openFieldsDialog(BuildContext context, String categoryId, PassFile passFile) {
  List<Map<String, dynamic>> fields = getPassFields(passFile);
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (context) => AddDateFormatAssistant(
      categoryId: categoryId,
      passFile: passFile,
      fields: fields, 
    ),
  );
}