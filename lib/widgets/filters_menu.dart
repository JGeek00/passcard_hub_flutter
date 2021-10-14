import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:passcard_hub/providers/categories_provider.dart';

class FiltersMenu extends StatelessWidget {
  const FiltersMenu({Key? key,}) : super(key: key);

  String _getTranslatedType(BuildContext context, String type) {
    switch (type) {
      case 'coupon':
        return AppLocalizations.of(context)!.coupon;

      case 'transport':
        return AppLocalizations.of(context)!.transport;

      case 'eventTicket':
        return AppLocalizations.of(context)!.eventTicket;

      case 'generic':
        return AppLocalizations.of(context)!.generic;
        
      default:
        return AppLocalizations.of(context)!.notDefined;
    }
  }

  String _getTranslatedTitle(BuildContext context, String value) {
    switch (value) {
      case 'showAll':
        return AppLocalizations.of(context)!.showAll;

      case 'notCategorized':
        return AppLocalizations.of(context)!.showNotCategorized;

      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10)
        )
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10)
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.passFiltering,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      icon: const Icon(Icons.check),
                      tooltip: AppLocalizations.of(context)!.acceptAndClose,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context)!.status,
                  style: const TextStyle(
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
                    title: Text(AppLocalizations.of(context)!.active),
                    value: 'active', 
                    groupValue: categoriesProvider.selectedStatus, 
                    onChanged: (value) {
                      categoriesProvider.updateSelectedStatus('active');
                    }
                  ),
                  RadioListTile(
                    title: Text(AppLocalizations.of(context)!.archived),
                    value: 'archived', 
                    groupValue: categoriesProvider.selectedStatus, 
                    onChanged: (value) {
                      categoriesProvider.updateSelectedStatus('archived');
                    }
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  AppLocalizations.of(context)!.categories,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                itemCount: categoriesProvider.categoriesLabels.length,
                itemBuilder: (context, index) => RadioListTile(
                  title: Text(_getTranslatedTitle(context, categoriesProvider.categoriesLabels[index]['label'])),
                  value: categoriesProvider.categoriesLabels[index]['value'] as String, 
                  groupValue: categoriesProvider.categorySelected, 
                  subtitle: categoriesProvider.categoriesLabels[index]['type'] != '' 
                    ? Text(_getTranslatedType(context, categoriesProvider.categoriesLabels[index]['type']))
                    : null,
                  onChanged: (value) {
                    categoriesProvider.changeCategorySelected(
                      newSelected: value.toString(),
                      titleSelected: categoriesProvider.categoriesLabels[index]['label'] != '' 
                        ? categoriesProvider.categoriesLabels[index]['label'] as String
                        : '',
                    );
                  }
                ),
                shrinkWrap: true,
                primary: false,
              ),
            ],
          ),
        ),
      )
    );
  }
}