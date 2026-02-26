import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'zen_colors.dart';

/// 禅意主题配置
class ZenTheme {
  /// 获取主题数据
  static ThemeData getThemeData({required bool isLight}) {
    return isLight ? _lightTheme() : _darkTheme();
  }

  /// 浅色主题
  static ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ZenColors.bambooGreen,
      scaffoldBackgroundColor: ZenColors.paperWhite,
      
      colorScheme: ColorScheme.light(
        primary: ZenColors.bambooGreen,
        secondary: ZenColors.plumBlossom,
        surface: ZenColors.pureWhite,
        error: ZenColors.error,
        onPrimary: ZenColors.pureWhite,
        onSecondary: ZenColors.inkBlack,
        onSurface: ZenColors.inkBlack,
        onError: ZenColors.pureWhite,
      ),
      
      // 文字主题
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 72,
          fontWeight: FontWeight.w300,
          color: ZenColors.inkBlack,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: ZenColors.inkBlack,
        ),
        displaySmall: GoogleFonts.notoSerif(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: ZenColors.inkBlack,
        ),
        bodyLarge: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ZenColors.inkBlack,
        ),
        bodyMedium: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ZenColors.darkMist,
        ),
        labelLarge: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ZenColors.inkBlack,
        ),
      ),
      
      // 应用栏主题
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ZenColors.inkBlack),
        titleTextStyle: GoogleFonts.notoSerif(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ZenColors.inkBlack,
        ),
      ),
      
      // 卡片主题
      cardTheme: const CardThemeData(
        color: ZenColors.pureWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // 图标主题
      iconTheme: IconThemeData(
        color: ZenColors.inkBlack,
        size: 24,
      ),
      
      // 分割线主题
      dividerTheme: DividerThemeData(
        color: ZenColors.mistGray,
        thickness: 1,
      ),
    );
  }

  /// 深色主题
  static ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: ZenColors.lightBamboo,
      scaffoldBackgroundColor: ZenColors.deepInk,
      
      colorScheme: ColorScheme.dark(
        primary: ZenColors.lightBamboo,
        secondary: ZenColors.lightPlum,
        surface: ZenColors.inkBlack,
        error: ZenColors.error,
        onPrimary: ZenColors.deepInk,
        onSecondary: ZenColors.paperWhite,
        onSurface: ZenColors.paperWhite,
        onError: ZenColors.pureWhite,
      ),
      
      // 文字主题
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 72,
          fontWeight: FontWeight.w300,
          color: ZenColors.paperWhite,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: ZenColors.paperWhite,
        ),
        displaySmall: GoogleFonts.notoSerif(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: ZenColors.paperWhite,
        ),
        bodyLarge: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ZenColors.paperWhite,
        ),
        bodyMedium: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ZenColors.mistGray,
        ),
        labelLarge: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ZenColors.paperWhite,
        ),
      ),
      
      // 应用栏主题
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ZenColors.paperWhite),
        titleTextStyle: GoogleFonts.notoSerif(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ZenColors.paperWhite,
        ),
      ),
      
      // 卡片主题
      cardTheme: const CardThemeData(
        color: ZenColors.inkBlack,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // 图标主题
      iconTheme: IconThemeData(
        color: ZenColors.paperWhite,
        size: 24,
      ),
      
      // 分割线主题
      dividerTheme: DividerThemeData(
        color: ZenColors.darkMist,
        thickness: 1,
      ),
    );
  }
}
