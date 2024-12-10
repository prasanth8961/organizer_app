import 'package:flutter/material.dart';

class CurvedTextField extends StatelessWidget {
  const CurvedTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.keyboardType,
      this.maxLines,
      this.readOnly,
      this.onTap,
      this.onChanged,
      this.validator});

  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final bool? readOnly;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        readOnly: readOnly != null ? readOnly! : false,
        onTap: onTap,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
