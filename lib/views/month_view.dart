import 'package:calendar/cell.dart';
import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final double cellRadius;
  final EdgeInsets cellMargin;
  final Animation<double> animation;

  const MonthView({
    required GlobalKey key,
    required this.cellRadius,
    required this.cellMargin,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          50,
          (index) => Container(
            margin: cellMargin,
            child: Cell(
              index: index,
              containerKey: key as GlobalKey,
              animateIn: false,
              animation: animation,
            ),
            height: cellRadius,
            width: cellRadius,
          ),
        ),
      ),
    );
  }
}
