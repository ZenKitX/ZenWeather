/// 二十四节气工具类
class SolarTerms {
  /// 获取当前节气
  static String getCurrentSolarTerm() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;
    
    // 根据日期判断节气（简化版，实际应使用天文算法）
    if (month == 2 && day >= 3 && day <= 5) return '立春';
    if (month == 2 && day >= 18 && day <= 20) return '雨水';
    if (month == 3 && day >= 5 && day <= 7) return '惊蛰';
    if (month == 3 && day >= 20 && day <= 22) return '春分';
    if (month == 4 && day >= 4 && day <= 6) return '清明';
    if (month == 4 && day >= 19 && day <= 21) return '谷雨';
    if (month == 5 && day >= 5 && day <= 7) return '立夏';
    if (month == 5 && day >= 20 && day <= 22) return '小满';
    if (month == 6 && day >= 5 && day <= 7) return '芒种';
    if (month == 6 && day >= 21 && day <= 22) return '夏至';
    if (month == 7 && day >= 6 && day <= 8) return '小暑';
    if (month == 7 && day >= 22 && day <= 24) return '大暑';
    if (month == 8 && day >= 7 && day <= 9) return '立秋';
    if (month == 8 && day >= 22 && day <= 24) return '处暑';
    if (month == 9 && day >= 7 && day <= 9) return '白露';
    if (month == 9 && day >= 22 && day <= 24) return '秋分';
    if (month == 10 && day >= 8 && day <= 9) return '寒露';
    if (month == 10 && day >= 23 && day <= 24) return '霜降';
    if (month == 11 && day >= 7 && day <= 8) return '立冬';
    if (month == 11 && day >= 22 && day <= 23) return '小雪';
    if (month == 12 && day >= 6 && day <= 8) return '大雪';
    if (month == 12 && day >= 21 && day <= 23) return '冬至';
    if (month == 1 && day >= 5 && day <= 7) return '小寒';
    if (month == 1 && day >= 20 && day <= 21) return '大寒';
    
    return '';
  }

  /// 获取当前季节
  static String getCurrentSeason() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) return '春';
    if (month >= 6 && month <= 8) return '夏';
    if (month >= 9 && month <= 11) return '秋';
    return '冬';
  }

  /// 获取节气描述
  static String getSolarTermDescription(String solarTerm) {
    final descriptions = {
      '立春': '春季开始，万物复苏',
      '雨水': '降雨开始，雨量渐增',
      '惊蛰': '春雷乍动，蛰虫惊醒',
      '春分': '昼夜平分，春意盎然',
      '清明': '天清地明，春暖花开',
      '谷雨': '雨生百谷，播种时节',
      '立夏': '夏季开始，万物生长',
      '小满': '麦粒渐满，夏熟作物',
      '芒种': '有芒作物，适时播种',
      '夏至': '白昼最长，盛夏来临',
      '小暑': '暑气渐盛，天气炎热',
      '大暑': '一年最热，酷暑难耐',
      '立秋': '秋季开始，暑去凉来',
      '处暑': '暑气消退，秋高气爽',
      '白露': '露凝而白，秋意渐浓',
      '秋分': '昼夜平分，秋收时节',
      '寒露': '露气寒冷，将要结霜',
      '霜降': '天气渐冷，开始降霜',
      '立冬': '冬季开始，万物收藏',
      '小雪': '开始降雪，气温下降',
      '大雪': '降雪增多，天寒地冻',
      '冬至': '白昼最短，数九寒天',
      '小寒': '天气寒冷，尚未大寒',
      '大寒': '一年最冷，冰天雪地',
    };
    
    return descriptions[solarTerm] ?? '';
  }

  /// 判断是否在节气当天
  static bool isSolarTermDay() {
    return getCurrentSolarTerm().isNotEmpty;
  }

  /// 获取节气颜色
  static int getSolarTermColor(String solarTerm) {
    // 春季 - 绿色系
    if (['立春', '雨水', '惊蛰', '春分', '清明', '谷雨'].contains(solarTerm)) {
      return 0xFF7C9885; // 竹绿
    }
    
    // 夏季 - 蓝色系
    if (['立夏', '小满', '芒种', '夏至', '小暑', '大暑'].contains(solarTerm)) {
      return 0xFF87CEEB; // 天青
    }
    
    // 秋季 - 橙色系
    if (['立秋', '处暑', '白露', '秋分', '寒露', '霜降'].contains(solarTerm)) {
      return 0xFFFF9966; // 暮橙
    }
    
    // 冬季 - 灰色系
    if (['立冬', '小雪', '大雪', '冬至', '小寒', '大寒'].contains(solarTerm)) {
      return 0xFFE0E0E0; // 雾灰
    }
    
    return 0xFF7C9885; // 默认竹绿
  }
}
