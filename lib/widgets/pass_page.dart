import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:passcard_hub/widgets/pass_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PassPage extends StatelessWidget {
  final PassFile? passFile;
  final void Function(PassFile) removePass;
  final void Function(PassFile) archivePass;
  final String selectedStatus;

  const PassPage({
    Key? key,
    required this.passFile,
    required this.removePass,
    required this.archivePass,
    required this.selectedStatus,
  }) : super(key: key);

  Widget _deleteDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Borrar pase",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: const Text(
        "¿Estás seguro de que deseas borrar este pase?\n\n Esta acción no es reversible.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text("Cancelar")
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            removePass(passFile!);
          }, 
          child: const Text("Aceptar")
        ),
      ],
    );
  }

  Widget _scrollableDetailsList(BuildContext context, ScrollController sc) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        overscroll: false,
      ),
      child: ListView(
        controller: sc,
        shrinkWrap: true,
        primary: false,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: const Text(
                "Detalles",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      archivePass(passFile!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          margin: const EdgeInsets.all(10),
                          content: Text(selectedStatus == 'active' ? "Pase movido a archivo" : "Pase sacado del archivo"),
                        ),
                      );
                    }, 
                    icon: selectedStatus == 'active' ? 
                      Icon(
                        Icons.archive,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      )
                    : Icon(
                      Icons.unarchive,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    tooltip: selectedStatus == 'active' ?
                      "Archivar pase" : "Desarchivar pase",
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (context) => _deleteDialog(context),
                      );
                    }, 
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    tooltip: "Borrar pase",
                  ),
                ],
              )
            ),
          ),
          ...passFile!.pass.boardingPass!.headerFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          ...passFile!.pass.boardingPass!.primaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          ...passFile!.pass.boardingPass!.auxiliaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          ...passFile!.pass.boardingPass!.secondaryFields!.map((item) => ListTile(
            title: Text(item.label!),
            subtitle: Text(item.value!),
          )).toList(),
          ...passFile!.pass.boardingPass!.backFields!.map((item) {
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
      minHeight: MediaQuery.of(context).size.height - 620 < 150 ? MediaQuery.of(context).size.height - 620 : 150,
      maxHeight: MediaQuery.of(context).size.height - 300,
      backdropOpacity: 1.0,
      body: CardWidget(passFile: passFile),
      panelBuilder: (ScrollController sc) => _scrollableDetailsList(context, sc),
      color: Theme.of(context).cardColor,
    );
  }
}