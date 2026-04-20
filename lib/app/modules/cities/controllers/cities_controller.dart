import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import '../../../data/local/storage_service.dart';
import '../../../data/models/city_model.dart';

/// 城市管理控制器 - 重构版
class CitiesController extends GetxController {
  final weather_kit.WeatherService _weatherService = weather_kit.WeatherService(
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
        final result = await _weatherService.getWeatherByCity(city: city);

        result.fold(
          (weather) {
            loadedCities.add(CityModel(
              name: weather.location.name,
              region: weather.location.region,
              country: weather.location.country,
              lat: weather.location.lat,
              lon: weather.location.lon,
              currentTemp: '${weather.current.tempC.round()}°',
              weatherCondition: weather.current.conditionText,
              weatherIcon: weather.current.conditionText,
            ));
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
          searchResults.value = [
            CityModel(
              name: weather.location.name,
              region: weather.location.region,
              country: weather.location.country,
              lat: weather.location.lat,
              lon: weather.location.lon,
            ),
          ];
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
        final cityWithWeather = city.copyWithWeather(
          currentTemp: '${weather.current.tempC.round()}°',
          weatherCondition: weather.current.conditionText,
          weatherIcon: weather.current.conditionText,
        );

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

  /// 选择城市
  void selectCity(CityModel city) {
    currentCityName.value = city.name;
    // 导航到天气详情页
    Get.toNamed('/weather-detail', arguments: city);
  }
}
