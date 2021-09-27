import 'package:flutter/material.dart';
import 'package:pass_flutter/pass_flutter.dart';

import 'package:passhub/utils/pass_code.dart';

class CodeModal extends StatelessWidget {
  final String codeType;
  final PassFile passFile;

  const CodeModal({
    Key? key,
    required this.codeType,
    required this.passFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: getPassCode(codeType, passFile),
      ),
    );
  }
}