import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double fontSize;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final double padding;

  const CustomButton({
    this.icon,
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.fontSize = 16,
    this.backgroundColor = Colors.green,
    this.padding = 4,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // onPressed: isLoading ? null : onPressed,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : Colors.green,
          foregroundColor: isOutlined
              ? Colors.green
              : Colors.white,
          elevation: isOutlined ? 0 : 2,
          side: isOutlined
              ? BorderSide(color: Colors.green)
              : null,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(icon),
                  Text(
                    text,
                    style: TextStyle(
                      color: isOutlined
                          ? Colors.green
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
