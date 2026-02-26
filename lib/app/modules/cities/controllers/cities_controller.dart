import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/city_model.dart';
import '../../../services/weather_service.dart';

/// 城市管理控制器
class CitiesController extends GetxController {
  final WeatherService _weatherService = WeatherService();

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

  /// 加载城市列表
  Future<void> _loadCities() async {
    isLoading.value = true;
    
    try {
      final cityNames = StorageService.getFavoriteCities();
      
      // 为每个城市获取天气数据
      final List<CityModel> loadedCities = [];
      for (final cityName in cityNames) {
        final weather = await _weatherService.getWeatherByCity(cityName);
        if (weather != null) {
          loadedCities.add(CityModel(
            name: weather.location.name,
            region: weather.location.region,
            country: weather.location.country,
            lat: weather.location.lat,
            lon: weather.location.lon,
            currentTemp: '${weather.current.tempC.round()}°',
            weatherCondition: weather.current.conditionText,
            weatherIcon: weather.current.icon,
          ));
        }
      }
      
      cities.value = loadedCities;
    } finally {
      isLoading.value = false;
    }
  }

  /// 搜索城市
  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    
    try {
      final results = await _weatherService.searchCities(query);
      searchResults.value = results.map((location) => CityModel(
        name: location.name,
        region: location.region,
        country: location.country,
        lat: location.lat,
        lon: location.lon,
      )).toList();
    } finally {
      isSearching.value = false;
    }
  }

  /// 添加城市
  Future<void> addCity(CityModel city) async {
    // 检查是否已存在
    if (cities.any((c) => c.name == city.name)) {
      Get.snackbar('提示', '该城市已添加');
      return;
    }

    // 获取天气数据
    final weather = await _weatherService.getWeatherByCity(city.name);
    if (weather != null) {
      final cityWithWeather = city.copyWithWeather(
        currentTemp: '${weather.current.tempC.round()}°',
        weatherCondition: weather.current.conditionText,
        weatherIcon: weather.current.icon,
      );
      
      cities.add(cityWithWeather);
      
      // 保存到本地
      await _saveCities();
      
      Get.back();
      Get.snackbar('成功', '已添加 ${city.name}');
    }
  }

  /// 删除城市
  Future<void> removeCity(int index) async {
    cities.removeAt(index);
    await _saveCities();
    Get.snackbar('成功', '已删除城市');
  }

  /// 切换到指定城市
  void switchToCity(CityModel city) {
    currentCityName.value = city.name;
    Get.back(result: city);
  }

  /// 刷新城市天气
  Future<void> refreshCities() async {
    await _loadCities();
  }

  /// 保存城市列表
  Future<void> _saveCities() async {
    final cityNames = cities.map((c) => c.name).toList();
    await StorageService.setFavoriteCities(cityNames);
  }
}
