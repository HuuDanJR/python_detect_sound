import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  final int n;
  const NumberWidget({super.key, required this.n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.displayLarge;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: n.toDouble()),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Text(
          value.toInt().toString(),
          style: textTheme,
        );
      },
    );
  }
}
