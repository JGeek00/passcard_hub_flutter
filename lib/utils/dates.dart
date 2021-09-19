import 'package:intl/intl.dart';

import 'package:pass_flutter/pass_flutter.dart';

List<PassFile?> sortPassDates({
  required List<PassFile?> items, 
  required field, 
  required index
}) {
  if (items.length >= 2) {
    items.sort((a, b) => DateFormat('dd-MM-yyyy HH:mm').parse(a!.pass.boardingPass![DynamicAccess(field: field, index: index)]!).compareTo(DateFormat('dd-MM-yyyy HH:mm').parse(b!.pass.boardingPass![DynamicAccess(field: field, index: index)]!)));
    return items;
  }
  else {
    return items;
  }
}