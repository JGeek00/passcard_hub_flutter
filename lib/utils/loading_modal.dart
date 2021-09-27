import 'package:flutter/material.dart';

import 'package:passhub/widgets/loading_modal.dart';

void showLoadingModal(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context, 
    builder: (context) => const LoadingModal()
  );
}

void hideLoadingModal(BuildContext context) {
  Navigator.of(context).pop();
}