import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:buswallet/models/pass_category.dart';

class FiltersMenu extends StatelessWidget {
  final List<PassCategory> options;
  final String selected;
  final void Function(String?) onChange;

  const FiltersMenu({
    Key? key,
    required this.options,
    required this.selected,
    required this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  value: "all", 
                  groupValue: selected, 
                  onChanged: onChange
                ),
                ...options.map((option) => RadioListTile(
                  title: Text(option.name),
                  value: option.id, 
                  groupValue: selected, 
                  onChanged: onChange
                )).toList(),
                RadioListTile(
                  title: const Text("Ver no categorizados"),
                  value: "not_categorized", 
                  groupValue: selected, 
                  onChanged: onChange
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}