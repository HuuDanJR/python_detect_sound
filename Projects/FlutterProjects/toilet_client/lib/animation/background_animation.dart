import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  final Widget? widget;
  final double? width;
  final double? height;
  final List<dynamic>? colorList;

  const AnimatedGradient({super.key, 
    required this.widget,
    required this.width,
    required this.height,
    required this.colorList,
  });

  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  // List<dynamic> colorList = [
  //   MyColor.blueBG,
  //   Colors.lightBlueAccent,
  //   MyColor.blueBG3,
  //   Colors.lightBlue,
  //   MyColor.blueBG4,
  //   MyColor.blueBG2,
  //   MyColor.blueBG5,
  // ];
  int index = 0;
  late Color bottomColor;
  late Color topColor;

  @override
  void initState() {
    super.initState();
    bottomColor = widget.colorList![index];
    topColor = widget.colorList![(index + 1) % widget.colorList!.length];
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        index = (index + 1) % widget.colorList!.length;
        bottomColor = widget.colorList![index];
        topColor = widget.colorList![(index + 1) % widget.colorList!.length];
      });
      _startAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [bottomColor, topColor],
        ),
      ),
      child: widget.widget,
    );
  }
}
