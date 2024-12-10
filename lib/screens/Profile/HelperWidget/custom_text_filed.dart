import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final Map controllers;
  final Map isEditable;
  final String label;
  final String labelKey;
  final void Function()? onPressed;

  const CustomTextFiled(
      {super.key,
      required this.controllers,
      required this.isEditable,
      required this.onPressed,
      required this.label,
      required this.labelKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllers[labelKey],
              enabled: isEditable[labelKey]!,
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          // IconButton(
          //     icon: Icon(isEditable[labelKey]! ? Icons.check : Icons.edit,
          //         color: isEditable[labelKey]! ? Colors.green : Colors.black54),
          //     onPressed: onPressed),
        ],
      ),
    );
  }
}
