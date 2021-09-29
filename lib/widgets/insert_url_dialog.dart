import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          return "Enlace no válido";
        }
        else {
          return null;
        }
      }
      else {
        return "Inserte un enlace";
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
      title: const Text('Inserta un enlace'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Descarga el pase desde el enlace insertado y lo guarda en la aplicación.",
              style: TextStyle(
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Enlace de Internet")
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
                    children: const [
                      Icon(Icons.paste),
                      SizedBox(width: 10),
                      Text("Pegar del portapapeles")
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
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Aceptar'),
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