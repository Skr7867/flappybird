// custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Button text
  final VoidCallback onPressed; // Button action
  final Color backgroundColor; // Background color
  final Color textColor; // Text color
  final double elevation; // Shadow depth
  final double borderRadius; // Corner radius
  final EdgeInsetsGeometry padding; // Padding inside button
  final TextStyle? textStyle; // Custom text style
  final bool isLoading; // Loading state

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // Default color
    this.textColor = Colors.white, // Default text color
    this.elevation = 2.0, // Default elevation
    this.borderRadius = 8.0, // Default border radius
    this.padding = const EdgeInsets.symmetric(
        horizontal: 50, vertical: 10.0), // Default padding
    this.textStyle, // Default text style
    this.isLoading = false, // Default loading state
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: textColor, // Spinner color
              ),
            )
          : Text(
              text,
              style: textStyle ??
                  TextStyle(
                      color: textColor,
                      fontSize: 16), // Apply custom text style
            ),
    );
  }
}
