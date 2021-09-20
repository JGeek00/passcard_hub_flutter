import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'package:buswallet/providers/passes_provider.dart';

class FiltersMenu extends StatelessWidget {
  final String selected;
  final void Function(String?) onChange;

  const FiltersMenu({
    Key? key,
    required this.selected,
    required this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context);

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10)
        )
      ),
      child: Column(
        children: [
          const Text(
            "Filtrado de pases",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
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
          ),
        ],
      )
    );
  }
}