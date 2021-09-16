import 'package:flutter/material.dart';

import 'package:pass_flutter/src/models/pass_json/structure_dictionary/fields/fields.dart';


class CardRow extends StatelessWidget {
  final List<Fields> items;

  const CardRow({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map<Widget>((item) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.label}'
            ),
            Text(
              '${item.value}'
            ),
          ],
        );
      }).toList(),
    );
  }
}