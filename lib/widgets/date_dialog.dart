import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class InsertDateDialogPage extends StatefulWidget {
  final String dateValue;
  final void Function(String) save;
  final void Function(bool) setValid;
  final void Function(String) updatePatternValue;

  const InsertDateDialogPage({
    Key? key, 
    required this.dateValue,
    required this.save,
    required this.setValid,
    required this.updatePatternValue,
  }) : super(key: key);

  static final List<Map<String, dynamic>> examples = [
    {
      'item': 'dd = día',
      'example': 'Ejemplo: 05'
    },
    {
      'item': 'MM = mes',
      'example': 'Ejemplo: 11'
    },
    {
      'item': 'MMM = mes (3 letras)',
      'example': 'Ejemplo: Feb'
    },
    {
      'item': 'yyyy = año',
      'example': '2021'
    },
    {
      'item': 'yy = año (2 dígitos)',
      'example': '21'
    },
    {
      'item': 'ss = segundos',
      'example': ''
    },
    {
      'item': 'mm = minutos',
      'example': ''
    },
    {
      'item': 'hh = horas',
      'example': ''
    },
  ];

  static const TextStyle exampleStyles = TextStyle(
    color: Colors.grey,
    fontSize: 14
  );

  @override
  State<InsertDateDialogPage> createState() => _InsertDateDialogPageState();
}

class _InsertDateDialogPageState extends State<InsertDateDialogPage> {
  String textValue = "";
  bool isValid = false;

  String? _validateField(String? value) {
    if (value != "" && value != null) {
      try {
        DateFormat(value).parse(widget.dateValue);
        isValid = true;
        return null;
      } catch (e) {
        isValid = false;
        return "El patrón introducido no corresponde a la fecha";
      }
    }
    else {
      isValid = false;
      return null;
    }
  }

  void checkValidDate(String? value) {
    if (value != "" && value != null) {
      try {
        DateFormat(value).parse(widget.dateValue);
        widget.setValid(true);
      } catch (e) {
        widget.setValid(false);
      }
    }
    else {
      widget.setValid(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                child: Text(
                  'Valor de fecha: ${widget.dateValue}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      textValue = value;
                    });
                    checkValidDate(value);
                    widget.updatePatternValue(value);
                  },
                  autovalidateMode: AutovalidateMode.always,
                  validator: _validateField,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Formato de fecha")
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "¡Importante!\nEs necesario introducir TODOS los datos que tiene el valor de la fecha para un correcto funcionamiento.",
                    textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    children: [
                      ...InsertDateDialogPage.examples.map((example) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            example['item'],
                            style: InsertDateDialogPage.exampleStyles,
                          ),
                          Text(
                            example['example'],
                            style: InsertDateDialogPage.exampleStyles,
                          ),
                        ],
                      )).toList(),
                    ]
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "Espacios y otros caracteres ( :  -  ,  / ), se escriben literalmente en el lugar donde corresponda.",
                  style: InsertDateDialogPage.exampleStyles,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: const [
                    Text(
                      "Ejemplos:",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "dd-MM-yyyy HH:mm\t\t\t=\t\t\t20-08-2021 14:30",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13
                      ),
                    ),
                    Text(
                      "MMM dd, yyyy\t\t\t=\t\t\tFeb 04, 2021",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13
                      ),
                    ),
                    Text(
                      "dd/MM/yy hh:mm:ss\t\t\t=\t\t\t03/06/21 16:20:25",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}