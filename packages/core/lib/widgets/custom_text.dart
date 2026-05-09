import 'package:flutter/material.dart';

enum TextVariant {
  h1,
  h2,
  h3,
  body,
  subtitle,
  button,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;

  const CustomText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: _getStyle().copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
      ),
    );
  }

  TextStyle _getStyle() {
    switch (variant) {
      case TextVariant.h1:
        return const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
      case TextVariant.h2:
        return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      case TextVariant.h3:
        return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
      case TextVariant.subtitle:
        return const TextStyle(fontSize: 16, color: Colors.grey);
      case TextVariant.button:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
      case TextVariant.body:
      return const TextStyle(fontSize: 16);
    }
  }
}
