import 'package:buswallet/utils/create_category.dart';
import 'package:buswallet/widgets/alert_quit_create_category.dart';
import 'package:buswallet/widgets/date_dialog.dart';
import 'package:buswallet/widgets/page_dialog_select_date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_flutter/pass_flutter.dart';

class CreateCategoryAssistant extends StatefulWidget {
  final PassFile passFile;
  final List<Map<String, dynamic>> fields;

  const CreateCategoryAssistant({
    Key? key,
    required this.passFile,
    required this.fields,
  }) : super(key: key);

  @override
  State<CreateCategoryAssistant> createState() => _CreateCategoryAssistantState();
}

class _CreateCategoryAssistantState extends State<CreateCategoryAssistant> {
  int page = 1;
  String? selectedField;
  String? fieldValue;
  String? patternValue;
  bool isDateValid = false;

  void selectedItem(String selected, String path, int index) {
    setState(() {
      selectedField = selected;
      fieldValue = getDateValue(widget.passFile, path, index);
    });
  }

  Widget _pageIndicator(int nPage) {
    if (page == nPage) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            nPage.toString(),
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            nPage.toString(),
          ),
        ),
      );
    }
  }

  void setIsDateValid(bool value) {
    setState(() {
      isDateValid = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget toRender;
    switch (page) {
      case 1:
        toRender = SelectFieldDateDialogPage(
          fields: widget.fields, 
          onChange: selectedItem, 
          selectedField: selectedField,
        );
        break;
        
      case 2:
        toRender = InsertDateDialogPage(
          dateValue: fieldValue!, 
          save: (value) => saveCategory(context, widget.passFile, patternValue!), 
          setValid: setIsDateValid,
          updatePatternValue: (value) {
            patternValue = value;
          },
        );
        break;
        
      default:
        toRender = const SizedBox();
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height-60,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Crear categoría",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context, 
                        builder: (context) => AlertQuitCreateCategory(
                          cancelCategoryCreation: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      );
                    }, 
                    icon :const Icon(Icons.close)
                  )
                ],
              ),
            ),
            Expanded(
              child: toRender,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: page == 2 ? (
                      () {
                        setState(() {
                          page = 1;
                        });
                      }
                    ) : null, 
                    child: const Text("Anterior"),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _pageIndicator(1),
                      _pageIndicator(2),
                    ],
                  ),

                  if (page == 1) TextButton(
                    onPressed: fieldValue != null ? (
                      () {
                        setState(() {
                          page = 2;
                        });
                      }
                    ) : null, 
                    child: const Text("Siguiente")
                  ),

                  if (page == 2) TextButton(
                    onPressed: isDateValid == true ? (
                      () {
                        saveCategory(context, widget.passFile, patternValue!);
                      }
                    ) : null, 
                    child: const Text("Finalizar")
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}