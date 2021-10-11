import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/widgets/pass_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PassPage extends StatelessWidget {
  final PassFile? passFile;
  final void Function(PassFile) removePass;
  final void Function(PassFile) archivePass;
  final String selectedStatus;
  final bool inAnimation;
  final bool loading;

  const PassPage({
    Key? key,
    required this.passFile,
    required this.removePass,
    required this.archivePass,
    required this.selectedStatus,
    required this.inAnimation,
    required this.loading,
  }) : super(key: key);

  Widget _deleteDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.deletePass,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        AppLocalizations.of(context)!.deletePassMessage,
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: Text(AppLocalizations.of(context)!.cancel)
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            removePass(passFile!);
          }, 
          child: Text(AppLocalizations.of(context)!.accept)
        ),
      ],
    );
  }

  Widget _scrollableDetailsList(BuildContext context, ScrollController sc) {
    var pass;
    if (passFile!.pass.boardingPass != null) {
      pass = passFile!.pass.boardingPass;
    }
    else if (passFile!.pass.coupon != null) {
      pass = passFile!.pass.coupon;
    }
    else if (passFile!.pass.eventTicket != null) {
      pass = passFile!.pass.eventTicket;
    }
    else if (passFile!.pass.generic != null) {
      pass = passFile!.pass.generic;
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        overscroll: false,
      ),
      child: loading == true ? const Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        controller: sc,
        shrinkWrap: true,
        primary: false,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Text(
                AppLocalizations.of(context)!.details,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: inAnimation == false ? (
                      () {
                        archivePass(passFile!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            margin: const EdgeInsets.all(10),
                            content: Text(selectedStatus == 'active' 
                              ? AppLocalizations.of(context)!.movedArchive 
                              : AppLocalizations.of(context)!.removedArchive
                            ),
                          ),
                        );
                      }
                    ) : null, 
                    icon: selectedStatus == 'active' ? 
                      Icon(
                        Icons.archive,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      )
                    : Icon(
                      Icons.unarchive,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    tooltip: selectedStatus == 'active' 
                    ? AppLocalizations.of(context)!.archivePass 
                    : AppLocalizations.of(context)!.unarchivePass,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: inAnimation == false ? (
                      () {
                        showDialog(
                          context: context, 
                          builder: (context) => _deleteDialog(context),
                        );
                      }
                    ) : null, 
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    tooltip: AppLocalizations.of(context)!.deletePass,
                  ),
                ],
              )
            ),
          ),
          if (pass.headerFields != null) ...pass.headerFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          if (pass.primaryFields != null) ...pass.primaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          if (pass.auxiliaryFields != null) ...pass.auxiliaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          if (pass.secondaryFields != null) ...pass.secondaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          if (pass.backFields != null) ...pass.backFields!.map((item) {
            if (item.label != null && item.value != null) {
              return ListTile(
                title: Text(item.label!),
                subtitle: Text(item.value!),
              );
            }
            else {
              return const SizedBox();
            }
          }).toList(),
          const SizedBox(height: 25)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      margin: const EdgeInsets.only(
        right: 5, 
        left: 5, 
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10), 
        topRight: Radius.circular(10)
      ),
      minHeight: (MediaQuery.of(context).size.height - 620) > 200 ? MediaQuery.of(context).size.height - 620 : 80,
      maxHeight: MediaQuery.of(context).size.height - 300,
      backdropOpacity: 1.0,
      body: CardWidget(
        passFile: passFile,
        loading: loading,
      ),
      panelBuilder: (ScrollController sc) => _scrollableDetailsList(context, sc),
      color: Theme.of(context).cardColor,
    );
  }
}