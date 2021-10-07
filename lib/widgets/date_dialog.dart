import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        return AppLocalizations.of(context)!.notMatchDate;
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
    List<Map<String, dynamic>> examples = [
      {
        'item': 'dd = ${AppLocalizations.of(context)!.month}',
        'example': '${AppLocalizations.of(context)!.example}: 05'
      },
      {
        'item': 'MM = ${AppLocalizations.of(context)!.month}',
        'example': '${AppLocalizations.of(context)!.example}: 11'
      },
      {
        'item': 'MMM = ${AppLocalizations.of(context)!.month} (3 ${AppLocalizations.of(context)!.letters})',
        'example': '${AppLocalizations.of(context)!.example}: Feb'
      },
      {
        'item': 'yyyy = ${AppLocalizations.of(context)!.year}',
        'example': '2021'
      },
      {
        'item': 'yy = ${AppLocalizations.of(context)!.year} (2 ${AppLocalizations.of(context)!.digits})',
        'example': '21'
      },
      {
        'item': 'ss = ${AppLocalizations.of(context)!.seconds}',
        'example': ''
      },
      {
        'item': 'mm = ${AppLocalizations.of(context)!.minutes}',
        'example': ''
      },
      {
        'item': 'hh = ${AppLocalizations.of(context)!.hours}',
        'example': ''
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                child: Text(
                  '${AppLocalizations.of(context)!.dateValue}: ${widget.dateValue}',
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(AppLocalizations.of(context)!.dateFormat)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.importantMessageDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                      ...examples.map((example) => Row(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!.spacesAndCharacters,
                  style: InsertDateDialogPage.exampleStyles,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.examples,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "dd-MM-yyyy HH:mm\t\t\t=\t\t\t20-08-2021 14:30",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13
                      ),
                    ),
                    const Text(
                      "MMM dd, yyyy\t\t\t=\t\t\tFeb 04, 2021",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13
                      ),
                    ),
                    const Text(
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