import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgContainer extends StatelessWidget {
  final String svgPath;
  final double height;
  final double width;
  const SvgContainer(
      {super.key,
      required this.svgPath,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      semanticsLabel: 'A red up arrow',
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
