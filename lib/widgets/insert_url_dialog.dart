import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsertUrlDialog extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) getFromUrl;

  const InsertUrlDialog({
    Key? key,
    required this.controller,
    required this.getFromUrl
  }) : super(key: key);

  @override
  State<InsertUrlDialog> createState() => _InsertUrlDialogState();
}

class _InsertUrlDialogState extends State<InsertUrlDialog> {
  bool urlHasErrors = true;

  @override
  Widget build(BuildContext context) {
    String? _validateUrl(String? url) {
      RegExp urlRegex = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      if (url != null && url != '') {
        if (urlRegex.hasMatch(url) != true) {
          return AppLocalizations.of(context)!.linkNotValid;
        }
        else {
          return null;
        }
      }
      else {
        return AppLocalizations.of(context)!.insertLink;
      }
    }

    void _enableDisableAccept(String? url) {
      RegExp urlRegex = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      if (urlRegex.hasMatch(url!) != true) {
        setState(() {
          urlHasErrors = true;
        });
      }
      else {
        setState(() {
          urlHasErrors = false;
        });
      }
    }

    void _pasteUrlFromClipboard() async {
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data!.text != null) {
        widget.controller.text = data.text!;
        _enableDisableAccept(data.text);
      }
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.insertLinkTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.insertLinkDescription,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.controller,
              onChanged: _enableDisableAccept,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => _validateUrl(value),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(AppLocalizations.of(context)!.internetLink)
              ),
            ),
            const SizedBox(height: 30),
            Flexible(
              child: OutlinedButton(
                onPressed: _pasteUrlFromClipboard, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.paste),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context)!.pasteClipboard)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.accept),
          onPressed: urlHasErrors != true ? (
            () {
              Navigator.of(context).pop();
              widget.getFromUrl(widget.controller.text);
            }
          ) : null,
        ),
      ],
    );
  }
}