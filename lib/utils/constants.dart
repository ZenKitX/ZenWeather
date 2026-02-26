/// 应用常量
class AppConstants {
  // 应用信息
  static const String appName = '禅意天气';
  static const String appVersion = '1.0.0';
  
  // API 配置（待配置）
  static const String weatherApiKey = 'YOUR_API_KEY_HERE';
  static const String weatherApiBaseUrl = 'https://api.weatherapi.com/v1';
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);
  
  // 默认值
  static const double defaultLatitude = 39.9042; // 北京
  static const double defaultLongitude = 116.4074;
}
