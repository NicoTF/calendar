import 'dart:math';

import 'package:entry/entry.dart';
import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  static const _interval = 30;
  final int index;
  final Animation<double> animation;
  final GlobalKey containerKey;
  final bool animateIn;

  const Cell({
    required this.index,
    required this.animation,
    required this.containerKey,
    required this.animateIn,
    Key? key,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  late Animation<Offset> positionTransition;
  late Animation<double> fadeTransition;
  final GlobalKey key = GlobalKey();

  void _calculateAnimation() {
    final space = (widget.containerKey.currentContext!.findRenderObject() as RenderBox);
    final spacePos = space.localToGlobal(Offset.zero);

    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(const Offset(.5, .5));
    final center = Offset(space.size.width / 2 + spacePos.dx, space.size.height / 2 + spacePos.dy);

    final direction = (center - pos).direction;
    final versor = Offset(cos(direction), sin(direction));
    final scale = -(max(space.size.width, space.size.height)) / (box.size.width * 2);
    positionTransition = Tween<Offset>(begin: Offset.zero, end: versor.scale(scale, scale)).animate(widget.animation);
  }

  @override
  void initState() {
    fadeTransition = Tween<double>(begin: widget.animateIn ? 0 : 1, end: widget.animateIn ? 1 : 0).animate(widget.animation);
    positionTransition = ConstantTween(Offset.zero).animate(widget.animation);
    if (!widget.animateIn) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => _calculateAnimation());
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant Cell oldWidget) {
    if (!widget.animateIn) _calculateAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: positionTransition,
      builder: (context, child) => FadeTransition(
        opacity: fadeTransition,
        child: SlideTransition(
          position: positionTransition,
          child: child,
        ),
      ),
      child: Entry.scale(
        delay: Duration(milliseconds: widget.index * Cell._interval),
        duration: const Duration(milliseconds: 500),
        child: Container(
          key: key,
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Colors.black,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.index.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
