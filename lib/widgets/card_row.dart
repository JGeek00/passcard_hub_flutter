import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: implementation_imports
import 'package:pass_flutter/src/models/pass_json/structure_dictionary/fields/fields.dart';


class CardRow extends StatelessWidget {
  final List<Fields> items;
  final Color? labelColor;
  final Color? valueColor;
  final double? labelSize;
  final double? valueSize;
  final bool? labelBold;
  final bool? valueBold;

  const CardRow({
    Key? key,
    required this.items,
    required this.labelColor,
    required this.valueColor,
    this.labelSize,
    this.valueSize,
    this.labelBold,
    this.valueBold,
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
                color: labelColor,
                fontSize: labelSize,
                fontWeight: labelBold == true
                  ? FontWeight.bold
                  : null
              ),
            ),
            Text(
              '${item.value}',
              overflow: TextOverflow.ellipsis,
               style: TextStyle(
                color: valueColor,
                fontSize: valueSize,
                fontWeight: valueBold == true
                  ? FontWeight.bold
                  : null
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}