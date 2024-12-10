import 'package:flutter/material.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:organizer_app/Utils/const_color.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            color: primaryColor,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            "No Results Found",
            style: textStyle(25, primaryColor, FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
