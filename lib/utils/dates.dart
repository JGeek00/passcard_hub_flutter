import 'package:intl/intl.dart';

import 'package:pass_flutter/pass_flutter.dart';

List<PassFile?> sortPassDates({
  required List<PassFile?> items, 
  required String field, 
  required int index
}) {
  if (items.length >= 2) {
    items.sort((a, b) => DateFormat('dd-MM-yyyy HH:mm').parse(a!.pass.boardingPass![DynamicAccess(field: field, index: index)]!).compareTo(DateFormat('dd-MM-yyyy HH:mm').parse(b!.pass.boardingPass![DynamicAccess(field: field, index: index)]!)));
    return items;
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