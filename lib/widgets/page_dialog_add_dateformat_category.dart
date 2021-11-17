import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogAddDateFormatCategory extends StatelessWidget {
  final void Function() accept;
  final void Function() cancel;

  const DialogAddDateFormatCategory({
    Key? key,
    required this.accept, 
    required this.cancel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.createCategoryTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        AppLocalizations.of(context)!.createCategoryDescription,
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: cancel, 
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: accept, 
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ],
    );
  }
}