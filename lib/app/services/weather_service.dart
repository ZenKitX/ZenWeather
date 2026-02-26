import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../data/models/weather_model.dart';
import '../../utils/constants.dart';
import 'api_service.dart';

/// 天气服务
class WeatherService {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  /// 根据城市名称获取天气
  Future<WeatherModel?> getWeatherByCity(String city) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.weatherApiBaseUrl}/forecast.json',
        queryParameters: {
          'key': AppConstants.weatherApiKey,
          'q': city,
          'days': 7,
          'aqi': 'yes',
          'alerts': 'yes',
          'lang': 'zh', // 中文
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _logger.e('获取天气失败: ${e.message}');
      return null;
    }
  }

  /// 根据经纬度获取天气
  Future<WeatherModel?> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.weatherApiBaseUrl}/forecast.json',
        queryParameters: {
          'key': AppConstants.weatherApiKey,
          'q': '$lat,$lon',
          'days': 7,
          'aqi': 'yes',
          'alerts': 'yes',
          'lang': 'zh',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _logger.e('获取天气失败: ${e.message}');
      return null;
    }
  }

  /// 搜索城市
  Future<List<LocationInfo>> searchCities(String query) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.weatherApiBaseUrl}/search.json',
        queryParameters: {
          'key': AppConstants.weatherApiKey,
          'q': query,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => LocationInfo.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('搜索城市失败: ${e.message}');
      return [];
    }
  }

  /// 获取当前天气（简化版）
  Future<WeatherModel?> getCurrentWeather(String location) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.weatherApiBaseUrl}/current.json',
        queryParameters: {
          'key': AppConstants.weatherApiKey,
          'q': location,
          'aqi': 'yes',
          'lang': 'zh',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _logger.e('获取当前天气失败: ${e.message}');
      return null;
    }
  }
}
