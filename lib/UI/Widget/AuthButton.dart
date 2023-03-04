import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AuthButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final double borderRadius;
  final double height;
  final double width;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.borderRadius,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 150, 247),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          )
        ),
      ),
    );
  }
}
