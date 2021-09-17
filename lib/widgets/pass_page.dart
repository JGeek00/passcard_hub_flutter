import 'package:flutter/material.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/card.dart';

class PassPage extends StatelessWidget {
  final PassFile? passFile;
  final void Function(PassFile) removePass;

  const PassPage({
    Key? key,
    required this.passFile,
    required this.removePass
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CardWidget(passFile: passFile),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    onTap: () => removePass(passFile!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.delete),
                        Text("Delete")
                      ],
                    )
                  )
                ]
              )
            ],
          ),
        )
      ],
    );
  }
}