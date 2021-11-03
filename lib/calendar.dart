library calendar;

import 'package:calendar/cell.dart';
import 'package:calendar/views/month_view.dart';
import 'package:flutter/material.dart';

enum CalendarView {
  day,
  week,
  month,
}

class Calendar extends StatefulWidget {
  final double? preferredCellRadius;
  final double? preferredCellRadiusFactor;
  final EdgeInsets cellMargin;
  final CalendarController controller;

  Calendar({
    this.preferredCellRadius,
    this.preferredCellRadiusFactor,
    this.cellMargin = const EdgeInsets.all(5),
    required this.controller,
    Key? key,
  }) : super(key: key) {
    assert(preferredCellRadius != null || preferredCellRadiusFactor != null);
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final key = GlobalKey();

  late CalendarView view;
  Widget? viewWidget;

  @override
  void initState() {
    widget.controller._state = this;
    view = widget.controller.view;
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    super.initState();
  }

  @override
  void didUpdateWidget(old) {
    widget.controller._state = this;
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = widget.preferredCellRadius ?? constraints.biggest.width * widget.preferredCellRadiusFactor!;
        return MonthView(
          key: key,
          cellRadius: radius,
          animation: controller,
          cellMargin: widget.cellMargin,
        );
      },
    );
  }
}

class CalendarController {
  CalendarView view;
  DateTime date;

  late _CalendarState _state;

  CalendarController({
    this.view = CalendarView.month,
    required this.date,
  });

  void animate() {
    if (_state.controller.status == AnimationStatus.forward || _state.controller.status == AnimationStatus.completed)
      _state.controller.reverse();
    else
      _state.controller.forward();
  }
}
