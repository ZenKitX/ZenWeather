import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
class StorageService {
  static late SharedPreferences _prefs;

  /// 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== 主题相关 ====================
  
  /// 保存主题模式
  static Future<bool> setThemeMode(bool isLight) async {
    return await _prefs.setBool(_StorageKeys.themeMode, isLight);
  }

  /// 获取主题模式
  static bool getThemeMode() {
    return _prefs.getBool(_StorageKeys.themeMode) ?? true; // 默认浅色
  }

  // ==================== 语言相关 ====================
  
  /// 保存语言代码
  static Future<bool> setLanguageCode(String languageCode) async {
    return await _prefs.setString(_StorageKeys.languageCode, languageCode);
  }

  /// 获取语言代码
  static String getLanguageCode() {
    return _prefs.getString(_StorageKeys.languageCode) ?? 'zh'; // 默认中文
  }

  // ==================== 位置相关 ====================
  
  /// 保存最后的位置
  static Future<bool> setLastLocation(double lat, double lon) async {
    await _prefs.setDouble(_StorageKeys.lastLatitude, lat);
    return await _prefs.setDouble(_StorageKeys.lastLongitude, lon);
  }

  /// 获取最后的纬度
  static double? getLastLatitude() {
    return _prefs.getDouble(_StorageKeys.lastLatitude);
  }

  /// 获取最后的经度
  static double? getLastLongitude() {
    return _prefs.getDouble(_StorageKeys.lastLongitude);
  }

  // ==================== 城市相关 ====================
  
  /// 保存收藏的城市列表
  static Future<bool> setFavoriteCities(List<String> cities) async {
    return await _prefs.setStringList(_StorageKeys.favoriteCities, cities);
  }

  /// 获取收藏的城市列表
  static List<String> getFavoriteCities() {
    return _prefs.getStringList(_StorageKeys.favoriteCities) ?? [];
  }

  // ==================== 首次启动 ====================
  
  /// 设置首次启动标记
  static Future<bool> setFirstLaunch(bool isFirst) async {
    return await _prefs.setBool(_StorageKeys.firstLaunch, isFirst);
  }

  /// 是否首次启动
  static bool isFirstLaunch() {
    return _prefs.getBool(_StorageKeys.firstLaunch) ?? true;
  }

  // ==================== 清除数据 ====================
  
  /// 清除所有数据
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}

/// 存储键名
class _StorageKeys {
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String lastLatitude = 'last_latitude';
  static const String lastLongitude = 'last_longitude';
  static const String favoriteCities = 'favorite_cities';
  static const String firstLaunch = 'first_launch';
}
