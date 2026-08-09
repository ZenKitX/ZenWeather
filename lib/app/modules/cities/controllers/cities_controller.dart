import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import '../../../data/local/storage_service.dart';
import '../../../data/models/city_model.dart';

/// 城市管理控制器 - 重构版
class CitiesController extends GetxController {
  final weather_kit.WeatherService _weatherService =
      weather_kit.WeatherService.withWeatherAPI(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY', defaultValue: ''),
  );

  // 城市列表
  final RxList<CityModel> cities = <CityModel>[].obs;

  // 搜索结果
  final RxList<CityModel> searchResults = <CityModel>[].obs;

  // 加载状态
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;

  // 当前选中的城市
  final RxString currentCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCities();
  }

  /// 加载城市列表（使用 WeatherKit）
  Future<void> _loadCities() async {
    isLoading.value = true;

    try {
      final cityNames = StorageService.getFavoriteCities();

      // 为每个城市获取天气数据
      final List<CityModel> loadedCities = [];
      for (final cityName in cityNames) {
        final result = await _weatherService.getWeatherByCity(city: cityName);

        result.fold(
          (weather) {
            loadedCities.add(_fromWeather(weather));
          },
          (error) {
            // 跳过失败的城市
          },
        );
      }

      cities.value = loadedCities;
    } finally {
      isLoading.value = false;
    }
  }

  /// 搜索城市（使用 WeatherKit）
  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;

    try {
      final result = await _weatherService.getWeatherByCity(city: query);

      result.fold(
        (weather) {
          searchResults.value = [_fromWeather(weather)];
        },
        (error) {
          searchResults.clear();
        },
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// 添加城市（使用 WeatherKit）
  Future<void> addCity(CityModel city) async {
    // 检查是否已存在
    if (cities.any((c) => c.name == city.name)) {
      Get.snackbar('提示', '该城市已添加');
      return;
    }

    // 获取天气数据
    final result = await _weatherService.getWeatherByCity(city: city.name);

    result.fold(
      (weather) {
        final cityWithWeather = _fromWeather(weather);
        cities.add(cityWithWeather);
        StorageService.addFavoriteCity(city.name);
        Get.snackbar('成功', '已添加 ${city.name}');
      },
      (error) {
        Get.snackbar('错误', '添加城市失败: ${error.message}');
      },
    );
  }

  /// 删除城市
  void removeCity(CityModel city) {
    cities.remove(city);
    StorageService.removeFavoriteCity(city.name);
    Get.snackbar('成功', '已删除 ${city.name}');
  }

  /// 刷新城市天气
  Future<void> refreshCities() async {
    await _loadCities();
  }

  /// 切换当前城市
  void switchToCity(CityModel city) {
    currentCityName.value = city.name;
  }

  /// 选择城市
  void selectCity(CityModel city) {
    currentCityName.value = city.name;
    // 导航到天气详情页
    Get.toNamed('/weather-detail', arguments: city.name);
  }

  /// 从 WeatherKit 数据构造城市模型
  CityModel _fromWeather(weather_kit.Weather weather) {
    return CityModel(
      name: weather.city.name,
      region: weather.city.region,
      country: weather.city.country,
      lat: weather.city.latitude,
      lon: weather.city.longitude,
      currentTemp: '${weather.currentTemperature.round()}°',
      weatherCondition: _conditionText(weather.condition),
      weatherIcon: _conditionIcon(weather.condition),
    );
  }

  /// 天气状况文本
  String _conditionText(weather_kit.WeatherCondition condition) {
    switch (condition) {
      case weather_kit.WeatherCondition.clear:
        return '晴';
      case weather_kit.WeatherCondition.partlyCloudy:
        return '多云';
      case weather_kit.WeatherCondition.cloudy:
        return '阴';
      case weather_kit.WeatherCondition.rain:
        return '雨';
      case weather_kit.WeatherCondition.snow:
        return '雪';
      case weather_kit.WeatherCondition.thunderstorm:
        return '雷雨';
      case weather_kit.WeatherCondition.fog:
        return '雾';
      case weather_kit.WeatherCondition.mist:
        return '薄雾';
      case weather_kit.WeatherCondition.unknown:
        return '未知';
    }
  }

  /// 天气图标
  String _conditionIcon(weather_kit.WeatherCondition condition) {
    switch (condition) {
      case weather_kit.WeatherCondition.clear:
        return '//cdn.weatherapi.com/weather/64x64/day/113.png';
      case weather_kit.WeatherCondition.partlyCloudy:
        return '//cdn.weatherapi.com/weather/64x64/day/116.png';
      case weather_kit.WeatherCondition.cloudy:
        return '//cdn.weatherapi.com/weather/64x64/day/119.png';
      case weather_kit.WeatherCondition.rain:
        return '//cdn.weatherapi.com/weather/64x64/day/302.png';
      case weather_kit.WeatherCondition.snow:
        return '//cdn.weatherapi.com/weather/64x64/day/326.png';
      case weather_kit.WeatherCondition.thunderstorm:
        return '//cdn.weatherapi.com/weather/64x64/day/200.png';
      case weather_kit.WeatherCondition.fog:
        return '//cdn.weatherapi.com/weather/64x64/day/248.png';
      case weather_kit.WeatherCondition.mist:
        return '//cdn.weatherapi.com/weather/64x64/day/143.png';
      case weather_kit.WeatherCondition.unknown:
        return '//cdn.weatherapi.com/weather/64x64/day/113.png';
    }
  }
}
