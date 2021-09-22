import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(
        (MediaQuery.of(context).size.width-120)/2
      ),
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}