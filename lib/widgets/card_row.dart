import 'package:flutter/material.dart';

// ignore: implementation_imports
import 'package:pass_flutter/src/models/pass_json/structure_dictionary/fields/fields.dart';


class CardRow extends StatelessWidget {
  final List<Fields> items;
  final Color? labelColor;
  final Color? valueColor;

  const CardRow({
    Key? key,
    required this.items,
    required this.labelColor,
    required this.valueColor,
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
              '${item.label}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: labelColor
              ),
            ),
            Text(
              '${item.value}',
              overflow: TextOverflow.ellipsis,
               style: TextStyle(
                color: valueColor,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}