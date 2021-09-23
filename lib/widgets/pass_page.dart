import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/card.dart';

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


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CardWidget(passFile: passFile),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(left: 40, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Detalles",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => archivePass(passFile!), 
                    icon: selectedStatus == 'active' ? 
                      const Icon(Icons.archive)
                    : const Icon(Icons.unarchive),
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
                    icon: const Icon(Icons.delete),
                    tooltip: "Borrar pase",
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}