import 'package:buswallet/providers/passes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/pass_page.dart';
import 'package:buswallet/models/pass_category.dart';
import 'package:buswallet/widgets/filters_menu.dart';
import 'package:provider/provider.dart';


class Passes extends StatefulWidget {
  final String selected;
  final void Function(String?) onSelectFiter;

  const Passes({
    Key? key,
    required this.selected,
    required this.onSelectFiter
  }) : super(key: key);

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
      builder: (context) => FiltersMenu(
        selected: widget.selected,
        onChange: widget.onSelectFiter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context);
    
    return passesProvider.getPasses.isNotEmpty ? Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Todos",
                style: TextStyle(
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
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => PassPage(
              passFile: passesProvider.getPasses[index], 
              removePass: passesProvider.deletePass,
            ),
            itemCount: passesProvider.getPasses.length,
          ),
        ),
      ],
    ) : SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
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
    );
  }
}