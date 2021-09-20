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
      exists.items.add(
        PassCategory(
          id: passFile.pass.passTypeIdentifier, 
          name: passFile.pass.organizationName, 
          dateFormat: "dd-MM-yyyy HH:mm",
          items: [
            passFile.pass.serialNumber
          ]
        )
      );
       
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
            passFile.pass.serialNumber
          ]
        ),
      );
    }

}