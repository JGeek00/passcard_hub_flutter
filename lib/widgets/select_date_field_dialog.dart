import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectFieldDateDialog extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final String? selectedValue;
  final void Function(String, String, int) onChange;
  final void Function() next;

  const SelectFieldDateDialog({
    Key? key,
    required this.fields,
    required this.selectedValue,
    required this.onChange,
    required this.next,
  }) : super(key: key);

  @override
  State<SelectFieldDateDialog> createState() => _SelectFieldDateDialogState();
}

class _SelectFieldDateDialogState extends State<SelectFieldDateDialog> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Campos del pase",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: Text(
              "Seleccionar de la lista el campo que contiene la fecha. En caso de existir varios con valor de fecha, elegir el que corresponda con la hora de salida.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          if (widget.fields.isNotEmpty) SizedBox(
            height: 400,
            child: ListView.builder(
              itemBuilder: (context, index) => RadioListTile<dynamic>(
                value: widget.fields[index]['key'], 
                groupValue: selectedItem, 
                onChanged: (value) {
                  widget.onChange(value, widget.fields[index]['path'], widget.fields[index]['index']);
                  setState(() {
                    selectedItem = value;
                  });
                },
                title: Text(widget.fields[index]['label']),
                subtitle: Text(widget.fields[index]['value']),
              ),
              itemCount: widget.fields.length,
            ),
          ),
          if (widget.fields.isEmpty) const SizedBox(
            height: 400,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: selectedItem != null ? (
                    () {
                      widget.next();
                    }
                  ) : null, 
                  child: const Text("Siguiente")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}