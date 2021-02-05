import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension TextExtension on Text {
  double calculateHeight(double maxWidth) {
    TextPainter painter = TextPainter(
      locale: Localizations.localeOf(Get.context, nullOk: true),
      maxLines: this.maxLines,
      textDirection: this.textDirection ?? TextDirection.ltr,
      text: TextSpan(
        text: this.data,
        style: this.style
      )
    );
    painter.layout(maxWidth: maxWidth);
    return painter.height;
  }
}