import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    required this.label,
    required this.hint,
    this.onSubmitted,
    this.obscureText,
    required this.focusNode,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final TextInputType? inputType;
  final String label;
  final int? maxLines;
  final String hint;
  final Function(String)? onSubmitted;
  final FocusNode focusNode;
  final bool ?obscureText;
  final Widget ?suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: const Color.fromARGB(255, 196, 196, 196),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          height: 50,
          child: TextFormField(
            
            obscureText: obscureText ?? false,
            controller: controller,
            enabled: true,
            maxLines: maxLines,
            keyboardType: inputType,
            style: GoogleFonts.roboto(
              color: const Color(0xff666666),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            onFieldSubmitted: onSubmitted,
            
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: GoogleFonts.roboto(
                color: const Color(0xff666666),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }
}
