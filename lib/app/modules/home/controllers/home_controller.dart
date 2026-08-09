import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import 'package:chinese_poetry_kit/chinese_poetry_kit.dart' as poetry_kit;
import 'package:solar_term_kit/solar_term_kit.dart' as solar_term_kit;
import 'package:location_kit/location_kit.dart' as location_kit;
import '../../../data/local/storage_service.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/poem_model.dart';
import '../../../../config/theme/seasonal_themes.dart';
import '../../../../config/theme/zen_theme.dart';

/// 首页控制器 - 重构版
class HomeController extends GetxController {
  // Package 服务
  final weather_kit.WeatherService _weatherService =
      weather_kit.WeatherService.withWeatherAPI(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY', defaultValue: ''),
  );

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

  /// 初始化季节和节气（使用 SolarTermKit）
  void _initSeasonAndSolarTerm() {
    // 使用 SolarTermKit 获取当前节气
    final solarTerm = solar_term_kit.SolarTerms.getCurrentSolarTerm();
    currentSolarTerm.value = solarTerm.name;

    // 使用 SolarTermKit 获取当前季节
    final season = solar_term_kit.SolarTerms.getCurrentSeason();
    currentSeason.value = _seasonName(season);

    // 判断是否是节气当天
    isSolarTermDay.value = _isSolarTermDay(solarTerm);

    // 获取季节主题色
    seasonalColors.value =
        SeasonalThemes.getSeasonalColors(currentSeason.value);
  }

  /// 季节名称
  String _seasonName(solar_term_kit.Season season) {
    switch (season) {
      case solar_term_kit.Season.spring:
        return '春';
      case solar_term_kit.Season.summer:
        return '夏';
      case solar_term_kit.Season.autumn:
        return '秋';
      case solar_term_kit.Season.winter:
        return '冬';
    }
  }

  /// 判断是否是节气当天
  bool _isSolarTermDay(solar_term_kit.SolarTerm solarTerm) {
    final solarTermTime = solar_term_kit.SolarTerms.getSolarTermTime(
      DateTime.now().year,
      solarTerm.index,
    );

    final now = DateTime.now();
    return now.year == solarTermTime.year &&
        now.month == solarTermTime.month &&
        now.day == solarTermTime.day;
  }

  /// 初始化天气数据（使用 WeatherKit 和 LocationKit）
  Future<void> _initWeatherData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 使用 LocationKit 获取当前位置
      final locationData = await location_kit.LocationKit.getCurrentLocation();

      // 成功获取位置，使用 WeatherKit 获取天气
      await _fetchWeatherByCoordinates(
        locationData.latitude,
        locationData.longitude,
      );
      locationName.value = _locationName(
        locationData.latitude,
        locationData.longitude,
      );
    } catch (e) {
      // 获取位置失败，使用默认城市（北京）
      await _fetchWeatherByCity('Beijing');
    } finally {
      isLoading.value = false;
    }
  }

  /// 根据坐标获取天气（使用 WeatherKit）
  Future<void> _fetchWeatherByCoordinates(double lat, double lon) async {
    final result = await _weatherService.getWeatherByLocation(
      latitude: lat,
      longitude: lon,
      includeHourly: true,
      includeDaily: true,
    );

    result.fold(
      (weatherKitData) {
        // 转换 WeatherKit 数据到 ZenWeather 数据模型
        weatherData.value = _convertWeatherData(weatherKitData);
        locationName.value = weatherKitData.city.name;
      },
      (error) {
        errorMessage.value = '获取天气数据失败: ${error.message}';
      },
    );
  }

  /// 根据城市名称获取天气（使用 WeatherKit）
  Future<void> _fetchWeatherByCity(String city) async {
    final result = await _weatherService.getWeatherByCity(
      city: city,
      includeHourly: true,
      includeDaily: true,
    );

    result.fold(
      (weatherKitData) {
        // 转换 WeatherKit 数据到 ZenWeather 数据模型
        weatherData.value = _convertWeatherData(weatherKitData);
        locationName.value = weatherKitData.city.name;
      },
      (error) {
        errorMessage.value = '获取天气数据失败: ${error.message}';
      },
    );
  }

  /// 根据坐标推测城市名（无逆地理编码时使用坐标显示）
  String _locationName(double lat, double lon) {
    // 默认使用坐标显示，后续可接入逆地理编码
    return '${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}';
  }

  /// 转换 WeatherKit 数据到 ZenWeather 数据模型
  WeatherModel _convertWeatherData(weather_kit.Weather kitData) {
    return WeatherModel(
      location: LocationInfo(
        name: kitData.city.name,
        region: kitData.city.region,
        country: kitData.city.country,
        lat: kitData.city.latitude,
        lon: kitData.city.longitude,
        localtime: kitData.currentTime.toIso8601String(),
      ),
      current: CurrentWeather(
        tempC: kitData.currentTemperature,
        tempF: kitData.currentTemperature * 9 / 5 + 32,
        condition: kitData.condition.name,
        conditionText: _conditionText(kitData.condition),
        icon: _conditionIcon(kitData.condition),
        windKph: kitData.windSpeed,
        windMph: kitData.windSpeed * 0.621371,
        humidity: kitData.humidity,
        feelslikeC: kitData.currentTemperature,
        feelslikeF: kitData.currentTemperature * 9 / 5 + 32,
        visKm: 10.0,
        visMiles: 6.2,
        pressureMb: 1013.0,
        pressureIn: 29.92,
        uv: 0,
      ),
      hourly: kitData.hourlyForecast.take(24).map((hourly) {
        return HourlyForecast(
          time: hourly.time.toIso8601String(),
          tempC: hourly.temperature,
          tempF: hourly.temperature * 9 / 5 + 32,
          condition: hourly.condition.name,
          conditionText: _conditionText(hourly.condition),
          icon: _conditionIcon(hourly.condition),
          windKph: hourly.windSpeed,
          chanceOfRain: hourly.humidity > 70 ? 60 : 10,
        );
      }).toList(),
      daily: kitData.dailyForecast.map((daily) {
        return DailyForecast(
          date: daily.date.toIso8601String(),
          maxTempC: daily.maxTemp,
          maxTempF: daily.maxTemp * 9 / 5 + 32,
          minTempC: daily.minTemp,
          minTempF: daily.minTemp * 9 / 5 + 32,
          condition: daily.condition.name,
          conditionText: _conditionText(daily.condition),
          icon: _conditionIcon(daily.condition),
          maxWindKph: 0.0,
          chanceOfRain: daily.uvIndex > 5 ? 20 : 10,
        );
      }).toList(),
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

  /// 根据天气状况获取诗词（使用 ChinesePoetryKit）
  PoemData getPoemByWeather() {
    if (weatherData.value == null) {
      final poem = poetry_kit.PoetryService.getRandomPoem();
      return _convertPoemData(poem);
    }

    // 如果是节气当天，优先显示节气诗词
    if (isSolarTermDay.value && currentSolarTerm.value.isNotEmpty) {
      final poem = poetry_kit.PoetryService.getPoem(
        solarTerm: currentSolarTerm.value,
      );
      return _convertPoemData(poem);
    }

    // 根据天气状况获取诗词
    final poem = poetry_kit.PoetryService.getPoem(
      weatherCondition: weatherData.value!.current.conditionText,
      season: currentSeason.value,
    );

    return _convertPoemData(poem);
  }

  /// 转换 ChinesePoetryKit 数据到 ZenWeather 数据模型
  PoemData _convertPoemData(poetry_kit.Poem poem) {
    return PoemData(
      title: poem.title,
      author: poem.author,
      dynasty: poem.dynasty,
      content: poem.content,
      tags: poem.tags,
    );
  }

  /// 获取节气描述（使用 SolarTermKit）
  String getSolarTermDescription() {
    if (currentSolarTerm.value.isEmpty) return '';

    final solarTerm =
        solar_term_kit.SolarTerms.getSolarTermByName(currentSolarTerm.value);
    return solarTerm?.description ?? '';
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
