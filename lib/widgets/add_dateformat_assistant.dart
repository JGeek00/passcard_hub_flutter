import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_flutter/pass_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:passcard_hub/utils/create_category.dart';
import 'package:passcard_hub/widgets/alert_quit_create_category.dart';
import 'package:passcard_hub/widgets/date_dialog.dart';
import 'package:passcard_hub/widgets/page_dialog_select_date_field.dart';
import 'package:passcard_hub/providers/app_config_provider.dart';

class AddDateFormatAssistant extends StatefulWidget {
  final String categoryId;
  final PassFile passFile;
  final List<Map<String, dynamic>> fields;

  const AddDateFormatAssistant({
    Key? key,
    required this.categoryId,
    required this.passFile,
    required this.fields,
  }) : super(key: key);

  @override
  State<AddDateFormatAssistant> createState() => _AddDateFormatAssistantState();
}

class _AddDateFormatAssistantState extends State<AddDateFormatAssistant> {
  int page = 1;
  String? selectedField;
  String? fieldValue;
  String patternValue = "";
  bool isDateValid = false;

  void selectedItem(String selected, String path, int index) {
    setState(() {
      selectedField = selected;
      fieldValue = getDateValue(widget.passFile, path, index);
    });
  }

  Widget _pageIndicator(int nPage) {
    final configProvider = Provider.of<AppConfigProvider>(context);

    if (page == nPage) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            nPage.toString(),
            style: TextStyle(
              color: configProvider.themeMode == ThemeMode.light ? (
                Colors.white
              ) : (
                Colors.black
              ),
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
          patternValue: patternValue,
          save: (value) => saveDateFormat(context, widget.categoryId, widget.passFile, patternValue), 
          setValid: setIsDateValid,
          updatePatternValue: (value) {
            setState(() {
              patternValue = value;
            });
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
                  Text(
                    AppLocalizations.of(context)!.createCategoryTitle,
                    style: const TextStyle(
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
                  ElevatedButton(
                    onPressed: page == 2 ? (
                      () {
                        setState(() {
                          patternValue = "";
                          isDateValid = false;
                          page = 1;
                        });
                      }
                    ) : null, 
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.previous),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _pageIndicator(1),
                      _pageIndicator(2),
                    ],
                  ),

                  if (page == 1) ElevatedButton(
                    onPressed: fieldValue != null ? (
                      () {
                        setState(() {
                          page = 2;
                        });
                      }
                    ) : null, 
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.next),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                        ),
                      ],
                    )
                  ),

                  if (page == 2) ElevatedButton(
                    onPressed: isDateValid == true ? (
                      () {
                        saveDateFormat(context, widget.categoryId, widget.passFile, patternValue);
                      }
                    ) : null, 
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.finish),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.check,
                          size: 18,
                        ),
                      ],
                    )
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