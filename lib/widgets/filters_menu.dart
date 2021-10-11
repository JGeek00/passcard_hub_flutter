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
        return "";
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: Text(
                  AppLocalizations.of(context)!.passFiltering,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
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
                    Navigator.of(context).pop();
                    categoriesProvider.updateSelectedStatus('active');
                  }
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.archived),
                  value: 'archived', 
                  groupValue: categoriesProvider.selectedStatus, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
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
            ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.showAll),
                  value: categoriesProvider.categoriesLabels[0]['value'] as String, 
                  groupValue: categoriesProvider.categorySelected, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    categoriesProvider.changeCategorySelected(newSelected: value.toString());
                  }
                ),
                ...categoriesProvider.getCategories.map((option) => RadioListTile(
                  title: Text(option.name),
                  value: option.id, 
                  groupValue: categoriesProvider.categorySelected, 
                  subtitle: Text(_getTranslatedType(context, option.type)),
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    categoriesProvider.changeCategorySelected(
                      newSelected: value.toString(), 
                      titleSelected: option.name,
                    );
                  }
                )).toList(),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.showNotCategorized),
                  value: categoriesProvider.categoriesLabels[1]['value'] as String, 
                  groupValue: categoriesProvider.categorySelected, 
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    categoriesProvider.changeCategorySelected(newSelected: value.toString());
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