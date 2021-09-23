import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'package:buswallet/providers/passes_provider.dart';

class FiltersMenu extends StatelessWidget {
  const FiltersMenu({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context);

    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10)
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: Text(
                  "Filtrado de pases",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Estado",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
            const SizedBox(height: 5),
            ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                RadioListTile(
                  title: const Text("Activos"),
                  value: 'active', 
                  groupValue: passesProvider.selectedStatus, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    passesProvider.updateSelectedStatus('active');
                  }
                ),
                RadioListTile(
                  title: const Text("Archivados"),
                  value: 'archived', 
                  groupValue: passesProvider.selectedStatus, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    passesProvider.updateSelectedStatus('archived');
                  }
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Categorías",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
            const SizedBox(height: 5),
            ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                RadioListTile(
                  title: const Text("Ver todos"),
                  value: passesProvider.categoriesLabels[0]['value'] as String, 
                  groupValue: passesProvider.categorySelected, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    passesProvider.changeCategorySelected(value.toString(), "Todos");
                  }
                ),
                ...passesProvider.getCategories.map((option) => RadioListTile(
                  title: Text(option.name),
                  value: option.id, 
                  groupValue: passesProvider.categorySelected, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    passesProvider.changeCategorySelected(value.toString(), option.name);
                  }
                )).toList(),
                RadioListTile(
                  title: const Text("Ver no categorizados"),
                  value: passesProvider.categoriesLabels[1]['value'] as String, 
                  groupValue: passesProvider.categorySelected, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    passesProvider.changeCategorySelected(value.toString(), "Sin categoría");
                  }
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}