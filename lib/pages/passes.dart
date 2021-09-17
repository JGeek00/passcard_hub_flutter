import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pass_flutter/pass_flutter.dart';

import 'package:buswallet/widgets/pass_page.dart';


class Home extends StatefulWidget {
  final List<PassFile?> passes;
  final void Function(PassFile) removePass;

  const Home({
    Key? key,
    required this.passes,
    required this.removePass
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return widget.passes.isNotEmpty ? (
      PageView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => PassPage(passFile: widget.passes[index], removePass: widget.removePass),
        itemCount: widget.passes.length,
      )
    ) : SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: (
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.local_activity,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No hay pases para mostrar",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey
              ),
            ),
          ],
        )
      ),
    );
  }
}