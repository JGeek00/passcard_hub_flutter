import 'package:buswallet/providers/categories_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/widgets/pass_page.dart';
import 'package:buswallet/providers/passes_provider.dart';
import 'package:buswallet/widgets/filters_menu.dart';


class Passes extends StatefulWidget {
  const Passes({Key? key,}) : super(key: key);

  @override
  State<Passes> createState() => _PassesState();
}

class _PassesState extends State<Passes> {
  void _showFiltersCard() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      builder: (context) => const FiltersMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoriesProvider.categoryTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (categoriesProvider.selectedStatus == 'archived') Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Archivados",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  IconButton(
                    onPressed: _showFiltersCard, 
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              )
            ],
          ),
        ),
        passesProvider.getPasses.isNotEmpty ? (
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => PassPage(
                passFile: passesProvider.getPasses[index], 
                selectedStatus: categoriesProvider.selectedStatus,
                removePass: (passFile) => passesProvider.deletePass(context, passFile),
                archivePass: (passFile) => categoriesProvider.selectedStatus == 'active' ? (
                  passesProvider.changePassStatus(passFile, 'archived')
                ) : (
                  passesProvider.changePassStatus(passFile, 'active')
                ),
              ),
              itemCount: passesProvider.getPasses.length,
            ),
          )
        ) : (
          Expanded(
            child: (
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_activity,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No hay pases para mostrar",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey
                    ),
                  ),
                ],
              )
            ),
          )
        ),
      ],
    );
  }
}