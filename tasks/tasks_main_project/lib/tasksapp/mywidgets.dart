import 'package:flutter/material.dart';

mytext(
  String text, {
  Color textColor = Colors.black,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  String? fontFamilyFromPubspec,
  bool shadow = false,
      TextAlign? textAlign
}) {
  return Text(
    text,
    textAlign: textAlign,
    // 1. المتغيرات العامة للويدجت نفسه
    // textAlign: TextAlign.center,          // محاذاة النص (يمن، يسار، مركز)
    // textDirection: TextDirection.rtl,    // اتجاه النص (من اليمين لليسار للعربي)
    // maxLines: 2,                         // أقصى عدد سطور يظهر
    overflow: TextOverflow.ellipsis, // شكل النص لو زاد عن السطور (يظهر نقط ...)
    // 2. متغيرات الـ Style (لب الموضوع)
    style: TextStyle(
      color: textColor,
      // لون النص
      backgroundColor: backgroundColor,
      // لون خلفية النص نفسه
      fontSize: fontSize,
      // حجم الخط
      fontWeight: fontWeight,
      // ثقل الخط (Bold, w500, w100...)
      fontStyle: fontStyle,
      // جعل الخط مائل
      fontFamily: fontFamilyFromPubspec,
      // نوع الخط (لازم يكون مضاف في الـ pubspec)

      // الظلال (Shadows)
      shadows: shadow
          ? [
              Shadow(
                color: Colors.black.withOpacity(0.5), // لون الظل
                offset: Offset(2, 2), // موقع الظل (يمين، أسفل)
                blurRadius: 4.0, // درجة تشتت أو نعومة الظل
              ),
            ]
          : null,
    ),
  );
}
