import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import 'package:chinese_poetry_kit/chinese_poetry_kit.dart' as poetry_kit;
import 'package:solar_term_kit/solar_term_kit.dart' as solar_term_kit;
import '../../../data/models/weather_model.dart';
import '../../../data/models/poem_model.dart';

/// 天气详情控制器 - 重构版
class WeatherDetailController extends GetxController {
  final weather_kit.WeatherService _weatherService = weather_kit.WeatherService(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY', defaultValue: ''),
  );
  final poetry_kit.PoetryService _poetryService = poetry_kit.PoetryService();

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
    final now = DateTime.now();
    final solarTerm = solar_term_kit.SolarTerms.getCurrentSolarTerm(now);
    currentSolarTerm.value = solarTerm.name;
    isSolarTermDay.value = _isSolarTermDay(solarTerm);
  }

  /// 判断是否是节气当天
  bool _isSolarTermDay(solar_term_kit.SolarTerm solarTerm) {
    final now = DateTime.now();
    final solarTermTime = solar_term_kit.SolarTerms.getSolarTermTime(
      now.year,
      solarTerm.index,
    );

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
      final poetryKitPoem = _poetryService.getPoem(
        solarTerm: currentSolarTerm.value,
      );
      if (poetryKitPoem != null) {
        poem.value = _convertPoemData(poetryKitPoem);
        return;
      }
    }

    // 根据天气状况获取诗词
    final poetryKitPoem = _poetryService.getPoem(
      weatherCondition: weather.value!.current.condition.text,
    );

    if (poetryKitPoem != null) {
      poem.value = _convertPoemData(poetryKitPoem);
    }
  }

  /// 转换 WeatherKit 数据到 ZenWeather 数据模型
  WeatherModel _convertWeatherData(weather_kit.WeatherData kitData) {
    return WeatherModel(
      location: Location(
        name: kitData.location.name,
        region: kitData.location.region,
        country: kitData.location.country,
        lat: kitData.location.lat,
        lon: kitData.location.lon,
        tzId: 'Asia/Shanghai',
        localtimeEpoch: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
      current: Current(
        lastUpdatedEpoch: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        tempC: kitData.current.tempC,
        tempF: kitData.current.tempC * 9 / 5 + 32,
        isDay: 1,
        condition: Condition(
          text: kitData.current.conditionText,
          icon: 'sunny',
          code: 1000,
        ),
        windKph: kitData.current.windKph,
        windDegree: 0,
        windDir: 'N',
        pressureMb: 1013.0,
        precipMm: 0.0,
        humidity: kitData.current.humidity,
        cloud: 25,
        feelslikeC: kitData.current.tempC,
        feelslikeF: kitData.current.tempC * 9 / 5 + 32,
        visKm: 10.0,
        uv: kitData.current.uvIndex.toDouble(),
        gustMph: 0.0,
      ),
      forecast: Forecast(
        forecastday: kitData.daily.map((daily) {
          return Forecastday(
            date: daily.date,
            dateEpoch: daily.date.millisecondsSinceEpoch ~/ 1000,
            day: Day(
              maxtempC: daily.maxTempC,
              maxtempF: daily.maxTempC * 9 / 5 + 32,
              mintempC: daily.minTempC,
              mintempF: daily.minTempC * 9 / 5 + 32,
              avgtempC: (daily.maxTempC + daily.minTempC) / 2,
              avgtempF: (daily.maxTempC + daily.minTempC) / 2 * 9 / 5 + 32,
              maxwindMph: 0.0,
              totalprecipMm: 0.0,
              avghumidity: 60,
              dailyWillItRain: daily.chanceOfRain > 50,
              dailyChanceOfRain: daily.chanceOfRain,
              condition: Condition(
                text: daily.conditionText,
                icon: 'sunny',
                code: 1000,
              ),
              uv: 5.0,
            ),
            astro: Astro(
              sunrise: '06:00',
              sunset: '18:00',
            ),
            hour: kitData.hourly
                .take(24)
                .map((hourly) => Hour(
                      timeEpoch: hourly.time.millisecondsSinceEpoch ~/ 1000,
                      tempC: hourly.tempC,
                      tempF: hourly.tempC * 9 / 5 + 32,
                      isDay: hourly.time.hour >= 6 && hourly.time.hour < 18 ? 1 : 0,
                      condition: Condition(
                        text: hourly.conditionText,
                        icon: 'sunny',
                        code: 1000,
                      ),
                      windKph: 10.0,
                      windDegree: 0,
                      windDir: 'N',
                      pressureMb: 1013.0,
                      precipMm: 0.0,
                      humidity: 60,
                      cloud: 25,
                      feelslikeC: hourly.tempC,
                      feelslikeF: hourly.tempC * 9 / 5 + 32,
                      windChillC: hourly.tempC,
                      windChillF: hourly.tempC * 9 / 5 + 32,
                      heatIndexC: hourly.tempC,
                      heatIndexF: hourly.tempC * 9 / 5 + 32,
                      dewpointC: hourly.tempC - 5,
                      dewPointF: (hourly.tempC - 5) * 9 / 5 + 32,
                      willItRain: hourly.chanceOfRain > 50,
                      chanceOfRain: hourly.chanceOfRain,
                      visKm: 10.0,
                    ))
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  /// 转换 ChinesePoetryKit 数据到 ZenWeather 数据模型
  PoemData _convertPoemData(poetry_kit.Poem poetryKitPoem) {
    return PoemData(
      title: poetryKitPoem.title,
      author: poetryKitPoem.author,
      dynasty: poetryKitPoem.dynasty,
      content: poetryKitPoem.content.join('\n'),
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
    return weather.value?.current.condition.text ?? '未知';
  }

  /// 获取节气描述
  String get solarTermDescription {
    if (currentSolarTerm.value.isEmpty) return '';

    final solarTerm = solar_term_kit.SolarTerms.getSolarTermByName(
      currentSolarTerm.value,
    );
    return solarTerm?.description ?? '';
  }

  /// 获取小时预报
  List<Hour> get hourlyForecast {
    return weather.value?.forecast.forecastday.firstOrNull?.hour ?? [];
  }

  /// 获取天预报
  List<Forecastday> get dailyForecast {
    return weather.value?.forecast.forecastday ?? [];
  }
}
