import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SvgButton extends StatelessWidget {
  final String svgPath;
  final Function() onPressed;
  final Color color;
  final double borderRadius;
  final double height;
  final double width;
  final double ?elevation;

  const SvgButton({
    super.key,
    required this.svgPath,
    required this.onPressed,
    required this.color,
    required this.borderRadius,
    required this.height,
    required this.width, this.elevation = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 100
      ),
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: SvgPicture.asset(
          svgPath,
          height: 25,
          width: 25,
        ),
      ),
    );
  }
}
