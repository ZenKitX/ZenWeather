import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/local/poem_database.dart';
import '../../../services/weather_service.dart';
import '../../../services/location_service.dart';
import '../../../../utils/solar_terms.dart';
import '../../../../config/theme/seasonal_themes.dart';
import '../../../../config/theme/zen_theme.dart';

/// 首页控制器
class HomeController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  // 主题模式
  final RxBool isLightTheme = true.obs;
  
  // 加载状态
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // 天气数据
  final Rx<WeatherModel?> weatherData = Rx<WeatherModel?>(null);
  
  // 位置信息
  final RxString locationName = '获取位置中...'.obs;
  
  // 季节和节气
  final RxString currentSeason = ''.obs;
  final RxString currentSolarTerm = ''.obs;
  final RxBool isSolarTermDay = false.obs;
  
  // 季节主题
  final Rx<SeasonalColors?> seasonalColors = Rx<SeasonalColors?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
    _initSeasonAndSolarTerm();
    _initWeatherData();
  }

  /// 加载主题设置
  void _loadTheme() {
    isLightTheme.value = StorageService.getThemeMode();
  }

  /// 初始化季节和节气
  void _initSeasonAndSolarTerm() {
    currentSeason.value = SolarTerms.getCurrentSeason();
    currentSolarTerm.value = SolarTerms.getCurrentSolarTerm();
    isSolarTermDay.value = SolarTerms.isSolarTermDay();
    seasonalColors.value = SeasonalThemes.getSeasonalColors(currentSeason.value);
  }

  /// 初始化天气数据
  Future<void> _initWeatherData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 尝试获取当前位置
      final locationData = await _locationService.getCurrentLocation();
      
      if (locationData != null && 
          locationData.latitude != null && 
          locationData.longitude != null) {
        // 根据位置获取天气
        await _fetchWeatherByLocation(
          locationData.latitude!,
          locationData.longitude!,
        );
      } else {
        // 如果无法获取位置，使用上次保存的位置或默认位置
        final lastLocation = await _locationService.getLastLocation();
        if (lastLocation != null && 
            lastLocation.latitude != null && 
            lastLocation.longitude != null) {
          await _fetchWeatherByLocation(
            lastLocation.latitude!,
            lastLocation.longitude!,
          );
        } else {
          // 使用默认城市（北京）
          await _fetchWeatherByCity('Beijing');
        }
      }
    } catch (e) {
      errorMessage.value = '获取天气数据失败，请检查网络连接';
    } finally {
      isLoading.value = false;
    }
  }

  /// 根据位置获取天气
  Future<void> _fetchWeatherByLocation(double lat, double lon) async {
    final weather = await _weatherService.getWeatherByLocation(lat, lon);
    if (weather != null) {
      weatherData.value = weather;
      locationName.value = weather.location.name;
    } else {
      errorMessage.value = '获取天气数据失败';
    }
  }

  /// 根据城市名称获取天气
  Future<void> _fetchWeatherByCity(String city) async {
    final weather = await _weatherService.getWeatherByCity(city);
    if (weather != null) {
      weatherData.value = weather;
      locationName.value = weather.location.name;
    } else {
      errorMessage.value = '获取天气数据失败';
    }
  }

  /// 切换主题
  void toggleTheme() {
    isLightTheme.value = !isLightTheme.value;
    StorageService.setThemeMode(isLightTheme.value);
    Get.changeTheme(
      isLightTheme.value 
          ? ZenTheme.getThemeData(isLight: true)
          : ZenTheme.getThemeData(isLight: false),
    );
  }

  /// 刷新天气数据
  Future<void> refreshWeather() async {
    await _initWeatherData();
  }

  /// 根据天气状况获取诗词
  PoemData getPoemByWeather() {
    if (weatherData.value == null) {
      return PoemDatabase.getPoemByWeather('');
    }

    // 如果是节气当天，优先显示节气诗词
    if (isSolarTermDay.value && currentSolarTerm.value.isNotEmpty) {
      return PoemDatabase.getPoemBySolarTerm(currentSolarTerm.value);
    }

    return PoemDatabase.getPoemByWeather(weatherData.value!.current.conditionText);
  }

  /// 获取节气描述
  String getSolarTermDescription() {
    if (currentSolarTerm.value.isEmpty) return '';
    return SolarTerms.getSolarTermDescription(currentSolarTerm.value);
  }

  /// 获取当前温度
  int get currentTemp {
    return weatherData.value?.current.tempC.round() ?? 0;
  }

  /// 获取天气描述
  String get weatherDesc {
    return weatherData.value?.current.conditionText ?? '未知';
  }

  /// 获取湿度
  int get humidity {
    return weatherData.value?.current.humidity ?? 0;
  }

  /// 获取风速
  double get windSpeed {
    return weatherData.value?.current.windKph ?? 0;
  }

  /// 获取能见度
  double get visibility {
    return weatherData.value?.current.visKm ?? 0;
  }

  /// 获取气压
  double get pressure {
    return weatherData.value?.current.pressureMb ?? 0;
  }
}
