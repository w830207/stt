import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTheme {
  static const Color black = Color(0xff3d3e3e);
  static const Color blueGrey = Color(0xffd7e4eb);
  static const Color orange = Color(0xfffb5d00);
  static const Color red = Color(0xffe06e67);
  static const Color pink = Color(0xfffceeeb);

  static BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30.r),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(-6, 4),
        blurRadius: 4,
      ),
    ],
  );

  static TextStyle get fileName => TextStyle(
        fontSize: 13.sp,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get createdTime => TextStyle(
        fontSize: 11.sp,
        color: Colors.black12,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get appbarTitle => TextStyle(
        fontSize: 22.sp,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      );
}
