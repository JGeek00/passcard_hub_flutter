import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectFieldDateDialogPage extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final void Function(String, String, int) onChange;
  final String? selectedField;

  const SelectFieldDateDialogPage({
    Key? key,
    required this.fields,
    required this.onChange,
    required this.selectedField,
  }) : super(key: key);

  @override
  State<SelectFieldDateDialogPage> createState() => _SelectFieldDateDialogPageState();
}

class _SelectFieldDateDialogPageState extends State<SelectFieldDateDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
          child: Text(
            "Seleccionar de la lista el campo que contiene la fecha. En caso de existir varios con valor de fecha, elegir el que corresponda con la fecha de salida.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 10),
        if (widget.fields.isNotEmpty) Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => RadioListTile<dynamic>(
              value: widget.fields[index]['key'], 
              groupValue: widget.selectedField, 
              onChanged: (value) {
                widget.onChange(value, widget.fields[index]['path'], widget.fields[index]['index']);
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
      ],
    );
  }
}