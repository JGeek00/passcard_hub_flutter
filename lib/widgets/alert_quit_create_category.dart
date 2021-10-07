import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlertQuitCreateCategory extends StatelessWidget {
  final void Function() cancelCategoryCreation;

  const AlertQuitCreateCategory({
    Key? key,
    required this.cancelCategoryCreation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.cancelCategoryCreationTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        AppLocalizations.of(context)!.cancelCategoryCreationWarning,
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: Text(AppLocalizations.of(context)!.no)
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            cancelCategoryCreation();
          }, 
          child: Text(AppLocalizations.of(context)!.yes)
        ),
      ],
    );
  }
}