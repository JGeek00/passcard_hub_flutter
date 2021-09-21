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
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                passesProvider.categoryTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              IconButton(
                onPressed: _showFiltersCard, 
                icon: const Icon(Icons.filter_list),
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
                removePass: passesProvider.deletePass,
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