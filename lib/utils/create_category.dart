import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/models/pass_category.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/utils/categories.dart';
import 'package:buswallet/widgets/date_dialog.dart';
import 'package:buswallet/widgets/select_date_field_dialog.dart';


String? selectedField;
String? selectedPath;
int? selectedIndex;

void selectedItem(String selected, String path, int index) {
  selectedField = selected;
  selectedPath = path;
  selectedIndex = index;
}

String getDateValue(PassFile passFile, String selectedPath, int selectedIndex) {
  return passFile.pass.boardingPass![DynamicAccess(field: selectedPath, index: selectedIndex)]!;
}

void save(BuildContext context, PassFile passFile, String datePattern) {
  final categoriesProvider = Provider.of<PassesProvider>(context, listen: false);
  Navigator.of(context).pop();
  categoriesProvider.addCategory(
    PassCategory(
      id: passFile.pass.passTypeIdentifier, 
      name: passFile.pass.organizationName, 
      dateFormat: datePattern,
      items: [
        passFile.pass.serialNumber.toString()
      ]
    ),
  );
}

void goBack(BuildContext context, PassFile passFile) {
  Navigator.of(context).pop();
  openFieldsDialog(context, passFile);
}

void doNext(BuildContext context, PassFile passFile) {
  if (selectedPath != null && selectedIndex != null) {
    String value = getDateValue(passFile, selectedPath!, selectedIndex!);
    Navigator.of(context).pop();
   
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => DateDialog(
        dateValue: value,
        save: (datePattern) => save(context, passFile, datePattern),
        goBack: () => goBack(context, passFile),
      ),
    );
  }
}


void openFieldsDialog(BuildContext context, PassFile passFile) {
  List<Map<String, dynamic>> fields = getPassFields(passFile);
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (context) => SelectFieldDateDialog(
      fields: fields, 
      selectedValue: selectedField,
      onChange: selectedItem,
      next: () => doNext(context, passFile),
    ),
  );
}