import 'package:flutter/material.dart';
import 'package:googlemapproject/utils/colors.dart';
class CustomButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color color;
  final VoidCallback? onPressed;

  const CustomButton({super.key,
     this.textColor = Colors.white,
    this.onPressed,
    required this.title,
     this.color = buttonMainColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(30),
          )
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )
    );
  }
}
