import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import 'package:chinese_poetry_kit/chinese_poetry_kit.dart' as poetry_kit;
import 'package:solar_term_kit/solar_term_kit.dart' as solar_term_kit;
import '../../../data/models/weather_model.dart';
import '../../../data/models/poem_model.dart';

/// 天气详情控制器 - 重构版
class WeatherDetailController extends GetxController {
  final weather_kit.WeatherService _weatherService =
      weather_kit.WeatherService.withWeatherAPI(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY', defaultValue: ''),
  );

  // 天气数据
  final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);

  // 加载状态
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // 城市名称
  late String cityName;

  // 诗词数据
  final Rx<PoemData?> poem = Rx<PoemData?>(null);

  // 节气信息
  final RxString currentSolarTerm = ''.obs;
  final RxBool isSolarTermDay = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 从路由参数获取城市名称
    cityName = Get.arguments as String? ?? '';
    if (cityName.isNotEmpty) {
      loadWeatherDetail();
    }
    _initSolarTerm();
  }

  /// 初始化节气信息（使用 SolarTermKit）
  void _initSolarTerm() {
    final solarTerm = solar_term_kit.SolarTerms.getCurrentSolarTerm();
    currentSolarTerm.value = solarTerm.name;
    isSolarTermDay.value = _isSolarTermDay(solarTerm);
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

  /// 加载天气详情（使用 WeatherKit）
  Future<void> loadWeatherDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _weatherService.getWeatherByCity(
        city: cityName,
        includeHourly: true,
        includeDaily: true,
      );

      result.fold(
        (weatherKitData) {
          weather.value = _convertWeatherData(weatherKitData);
          // 获取相关诗词（使用 ChinesePoetryKit）
          _loadRelatedPoem();
        },
        (error) {
          errorMessage.value = '获取天气数据失败: ${error.message}';
        },
      );
    } catch (e) {
      errorMessage.value = '网络错误：${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载相关诗词（使用 ChinesePoetryKit）
  void _loadRelatedPoem() {
    if (weather.value == null) return;

    // 如果是节气当天，优先显示节气诗词
    if (isSolarTermDay.value && currentSolarTerm.value.isNotEmpty) {
      final poetryKitPoem = poetry_kit.PoetryService.getPoem(
        solarTerm: currentSolarTerm.value,
      );
      poem.value = _convertPoemData(poetryKitPoem);
      return;
    }

    // 根据天气状况获取诗词
    final poetryKitPoem = poetry_kit.PoetryService.getPoem(
      weatherCondition: weather.value!.current.conditionText,
    );

    poem.value = _convertPoemData(poetryKitPoem);
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

  /// 转换 ChinesePoetryKit 数据到 ZenWeather 数据模型
  PoemData _convertPoemData(poetry_kit.Poem poetryKitPoem) {
    return PoemData(
      title: poetryKitPoem.title,
      author: poetryKitPoem.author,
      dynasty: poetryKitPoem.dynasty,
      content: poetryKitPoem.content,
      tags: poetryKitPoem.tags,
    );
  }

  /// 刷新天气
  Future<void> refreshWeather() async {
    await loadWeatherDetail();
  }

  /// 获取当前温度
  int get currentTemp {
    return weather.value?.current.tempC.round() ?? 0;
  }

  /// 获取天气描述
  String get weatherDesc {
    return weather.value?.current.conditionText ?? '未知';
  }

  /// 获取节气描述
  String get solarTermDescription {
    if (currentSolarTerm.value.isEmpty) return '';

    final solarTerm =
        solar_term_kit.SolarTerms.getSolarTermByName(currentSolarTerm.value);
    return solarTerm?.description ?? '';
  }

  /// 获取小时预报
  List<HourlyForecast> get hourlyForecast {
    return weather.value?.hourly ?? [];
  }

  /// 获取天预报
  List<DailyForecast> get dailyForecast {
    return weather.value?.daily ?? [];
  }
}
