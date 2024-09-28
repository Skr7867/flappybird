import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController emailController;
  final Widget? widgetSuffix;
  final Widget? widgetPrefix;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  const CustomTextFormField({
    super.key,
    required TextEditingController emailController,
    this.widgetSuffix,
    this.widgetPrefix,
    this.label = "Email",
    this.obscureText = false,
    this.keyboardType,
  }) : emailController = emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      obscureText: obscureText,
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: const Color(0xff261C12).withOpacity(0.1),
        filled: true,
        suffixIcon: widgetSuffix == null
            ? null
            : Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: widgetSuffix),
        prefixIcon: widgetPrefix == null
            ? null
            : Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: widgetPrefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
