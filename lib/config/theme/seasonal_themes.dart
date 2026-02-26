import 'package:flutter/material.dart';
import 'zen_colors.dart';

/// 四季主题配置
class SeasonalThemes {
  /// 获取季节主题颜色
  static SeasonalColors getSeasonalColors(String season) {
    switch (season) {
      case '春':
        return _springColors;
      case '夏':
        return _summerColors;
      case '秋':
        return _autumnColors;
      case '冬':
        return _winterColors;
      default:
        return _springColors;
    }
  }

  /// 春季配色
  static final SeasonalColors _springColors = SeasonalColors(
    primary: ZenColors.bambooGreen,
    secondary: Color(0xFFB8E6B8), // 嫩绿
    accent: Color(0xFFFFB6C1), // 樱粉
    background: Color(0xFFF0F8F0), // 春白
    cardBackground: Color(0xFFFFFFFF),
    textPrimary: ZenColors.inkBlack,
    textSecondary: Color(0xFF5A7A5A),
    seasonName: '春',
    seasonDescription: '春风拂面，万物复苏',
  );

  /// 夏季配色
  static final SeasonalColors _summerColors = SeasonalColors(
    primary: ZenColors.skyBlue,
    secondary: Color(0xFF87CEEB), // 天蓝
    accent: Color(0xFFFFD700), // 金黄
    background: Color(0xFFF0F8FF), // 夏白
    cardBackground: Color(0xFFFFFFFF),
    textPrimary: ZenColors.inkBlack,
    textSecondary: Color(0xFF4682B4),
    seasonName: '夏',
    seasonDescription: '绿树成荫，蝉鸣阵阵',
  );

  /// 秋季配色
  static final SeasonalColors _autumnColors = SeasonalColors(
    primary: ZenColors.sunsetOrange,
    secondary: Color(0xFFDEB887), // 枫黄
    accent: Color(0xFFCD853F), // 秋褐
    background: Color(0xFFFFF8F0), // 秋白
    cardBackground: Color(0xFFFFFFFF),
    textPrimary: ZenColors.inkBlack,
    textSecondary: Color(0xFF8B4513),
    seasonName: '秋',
    seasonDescription: '秋高气爽，层林尽染',
  );

  /// 冬季配色
  static final SeasonalColors _winterColors = SeasonalColors(
    primary: Color(0xFFB0C4DE), // 冬蓝
    secondary: Color(0xFFE0E0E0), // 雪白
    accent: Color(0xFF708090), // 冬灰
    background: Color(0xFFF5F5F5), // 冬白
    cardBackground: Color(0xFFFFFFFF),
    textPrimary: ZenColors.inkBlack,
    textSecondary: Color(0xFF696969),
    seasonName: '冬',
    seasonDescription: '银装素裹，静谧安宁',
  );

  /// 获取季节渐变色
  static LinearGradient getSeasonalGradient(String season) {
    final colors = getSeasonalColors(season);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors.background,
        colors.background.withOpacity(0.8),
      ],
    );
  }

  /// 获取季节图标
  static IconData getSeasonalIcon(String season) {
    switch (season) {
      case '春':
        return Icons.local_florist; // 花朵
      case '夏':
        return Icons.wb_sunny; // 太阳
      case '秋':
        return Icons.eco; // 叶子
      case '冬':
        return Icons.ac_unit; // 雪花
      default:
        return Icons.cloud;
    }
  }
}

/// 季节配色数据
class SeasonalColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final String seasonName;
  final String seasonDescription;

  SeasonalColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.seasonName,
    required this.seasonDescription,
  });
}
