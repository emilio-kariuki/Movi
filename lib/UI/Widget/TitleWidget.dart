import 'package:flutter/material.dart';

class TitleMovie extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const TitleMovie({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text("View All",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
