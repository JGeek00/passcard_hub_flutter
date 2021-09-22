import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogCreateCategory extends StatelessWidget {
  final void Function() accept;
  final void Function() cancel;

  const DialogCreateCategory({
    Key? key,
    required this.accept, 
    required this.cancel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Crear nueva categoría",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: const Text(
        "No existe ninguna categoría para el pase que se acaba de añadir. ¿Desea crear una nueva categoría?\n\nEn caso de no crear categoría el pase quedará sin categorizar.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: cancel, 
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: accept, 
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}