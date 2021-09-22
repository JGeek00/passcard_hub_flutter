import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertQuitCreateCategory extends StatelessWidget {
  final void Function() cancelCategoryCreation;

  const AlertQuitCreateCategory({
    Key? key,
    required this.cancelCategoryCreation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Cancelar creación",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: const Text(
        "Si cancela la creación de la categoría, el pase añadido quedará descategorizado.\n\n¿Desea cancelar?",
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text("No")
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            cancelCategoryCreation();
          }, 
          child: const Text("Si")
        ),
      ],
    );
  }
}