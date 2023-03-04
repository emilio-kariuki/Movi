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
    this.onSubmitted, required this.focusNode,
  });

  final TextEditingController controller;
  final TextInputType? inputType;
  final String label;
  final int? maxLines;
  final String hint;
  final Function(String)? onSubmitted;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: const Color(0xff666666),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
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
              hintText: hint,
              hintStyle: GoogleFonts.roboto(
            color: const Color(0xff666666),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border:  const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
            color: Color(0xff666666),
                  width: 1,
                  style: BorderStyle.solid
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 30, 136, 229),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }
}
