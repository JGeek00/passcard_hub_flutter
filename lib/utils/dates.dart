import 'package:intl/intl.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/models/pass_category.dart';


List<PassFile?> sortPassDates({
  required List<PassFile?> items,
  required List<PassCategory> categories,
}) {
  // Remove uncategorized passes
  List<PassFile?> filtered = items.where((item) {
    bool exists = false;
    for (var category in categories) {
      bool thisExists = false;
      for (var categoryItem in category.items) {
        if (categoryItem == item!.pass.serialNumber) {
          thisExists = true;
          break;
        }
      }
      if (thisExists == true) {
        exists = true;
        break;
      }
    }
    if (exists == true) {
     return true;
    }
    else {
      return false;
    }
  }).toList();

  if (filtered.length >= 2) {
    //Filter categorized passes
    filtered.sort((a, b) {
      PassCategory? aCategory;
      for (var thisCategory in categories) {
        bool thisExists = false;
        for (var item in thisCategory.items) {
          if (item == a!.pass.serialNumber) {
            thisExists = true;
            break;
          }
        }
        if (thisExists == true) {
          aCategory = thisCategory;
          break;
        }
      }

      PassCategory? bCategory;
      for (var thisCategory in categories) {
        bool thisExists = false;
        for (var item in thisCategory.items) {
          if (item == b!.pass.serialNumber) {
            thisExists = true;
            break;
          }
        }
        if (thisExists == true) {
          bCategory = thisCategory;
          break;
        }
      }

      return DateFormat(aCategory!.dateFormat).parse(a!.pass.boardingPass![DynamicAccess(field: aCategory.path!, index: aCategory.index!)]!).compareTo(DateFormat(bCategory!.dateFormat).parse(b!.pass.boardingPass![DynamicAccess(field: bCategory.path!, index: bCategory.index!)]!));
    });

    // Add not categorized to the end of the array
    List<PassFile?> notCategorized = [...items];
    notCategorized.removeWhere((item) => filtered.contains(item));

    return [...filtered, ...notCategorized];
  }
  else {
    return items;
  }
}

List<String> dateTimeFormats = [
  'dd-MM-yyyy',
  'dd-MM-yyyy HH:mm',
  'dd-MM-yyyy HH:mm:ss',
  'dd-MM HH:mm:ss',
  'dd-MM HH:mm',
  'dd-MM',
  'dd-MMM-yy HH:mm:ss',
  'dd-MMM-yy HH:mm',
  'dd-MMM-yy',
  'dd-MMM-yyyy HH:mm:ss',
  'dd-MMM-yyyy HH:mm',
  'dd-MMM-yyyy',
  // 'yyyy-MM-dd HH:mm:ss'
  // 'yyyy-MM-dd HH:mm'
  // 'yyyy-MM-dd'
  // 'yy-MM-dd HH:mm:ss'
  // 'yy-MM-dd HH:mm'
  // 'yy-MM-dd',
  'dd/MM/yyyy',
  'dd/MM/yyyy HH:mm',
  'dd/MM/yyyy HH:mm:ss',
  'dd/MM HH:mm:ss',
  'dd/MM HH:mm',
  'dd/MM',
  'dd/MMM/yy HH:mm:ss',
  'dd/MMM/yy HH:mm',
  'dd/MMM/yy',
  'dd/MMM/yyyy HH:mm:ss',
  'dd/MMM/yyyy HH:mm',
  'dd/MMM/yyyy',
  // 'yyyy/MM/dd HH:mm:ss'
  // 'yyyy/MM/dd HH:mm'
  // 'yyyy/MM/dd'
  // 'yy/MM/dd HH:mm:ss'
  // 'yy/MM/dd HH:mm'
  // 'yy/MM/dd',
  'MMM dd, yy',
  'MMM dd, yy HH:mm:ss',
  'MMM dd, yy HH:mm',
  'MMM dd, yyyy',
  'MMM dd, yyyy HH:mm:ss',
  'MMM dd, yyyy HH:mm',
  'MMM dd yy',
  'MMM dd yy HH:mm:ss',
  'MMM dd yy HH:mm',
  'MMM dd yyyy',
  'MMM dd yyyy HH:mm:ss',
  'MMM dd yyyy HH:mm',
  'HH:mm',
  'HH:mm:ss',
  'mm:ss',
];

bool checkDateFormat(String dateString) {
  DateTime? result;
  for (var format in dateTimeFormats) {
    try {
      
      result = DateFormat(format).parse(dateString);
      if (result == dateString) {
        print('c $result $dateString');
        break;
      }
     
    } catch (e) {
      print('a $e');
    }
  }
  print('b $result');
  return false;
}