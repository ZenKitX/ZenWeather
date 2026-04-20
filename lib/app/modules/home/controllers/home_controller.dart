import 'package:get/get.dart';
import 'package:weather_kit/weather_kit.dart' as weather_kit;
import 'package:chinese_poetry_kit/chinese_poetry_kit.dart' as poetry_kit;
import 'package:solar_term_kit/solar_term_kit.dart' as solar_term_kit;
import 'package:location_kit/location_kit.dart' as location_kit;
import '../../../data/local/storage_service.dart';
import '../../../data/models/weather_model.dart';
import '../../../../config/theme/seasonal_themes.dart';
import '../../../../config/theme/zen_theme.dart';

/// 首页控制器 - 重构版
class HomeController extends GetxController {
  // Package 服务
  final weather_kit.WeatherService _weatherService = weather_kit.WeatherService(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY', defaultValue: ''),
    cache: weather_kit.WeatherCache(),
  );
  final poetry_kit.PoetryService _poetryService = poetry_kit.PoetryService();
  final location_kit.LocationService _locationService = location_kit.LocationService();

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
    final now = DateTime.now();

    // 使用 SolarTermKit 获取当前节气
    final solarTerm = solar_term_kit.SolarTerms.getCurrentSolarTerm(now);
    currentSolarTerm.value = solarTerm.name;

    // 使用 SolarTermKit 获取当前季节
    final season = solar_term_kit.SolarTerms.getCurrentSeason(now);
    currentSeason.value = season.name;

    // 判断是否是节气当天
    isSolarTermDay.value = _isSolarTermDay(solarTerm);

    // 获取季节主题色
    seasonalColors.value = SeasonalThemes.getSeasonalColors(currentSeason.value);
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

  /// 初始化天气数据（使用 WeatherKit 和 LocationKit）
  Future<void> _initWeatherData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 使用 LocationKit 获取当前位置
      final locationResult = await _locationService.getCurrentLocation();

      locationResult.fold(
        (locationData) async {
          // 成功获取位置，使用 WeatherKit 获取天气
          await _fetchWeatherByCoordinates(
            locationData.coordinates.latitude,
            locationData.coordinates.longitude,
          );
          locationName.value = locationData.name;
        },
        (error) async {
          // 获取位置失败，使用上次保存的位置或默认位置
          final lastLocation = await _locationService.getLastLocation();
          if (lastLocation != null) {
            await _fetchWeatherByCoordinates(
              lastLocation.coordinates.latitude,
              lastLocation.coordinates.longitude,
            );
          } else {
            // 使用默认城市（北京）
            await _fetchWeatherByCity('Beijing');
          }
        },
      );
    } catch (e) {
      errorMessage.value = '获取天气数据失败，请检查网络连接';
    } finally {
      isLoading.value = false;
    }
  }

  /// 根据坐标获取天气（使用 WeatherKit）
  Future<void> _fetchWeatherByCoordinates(double lat, double lon) async {
    final result = await _weatherService.getWeatherByCoordinates(
      lat: lat,
      lon: lon,
      includeHourly: true,
      includeDaily: true,
    );

    result.fold(
      (weatherKitData) {
        // 转换 WeatherKit 数据到 ZenWeather 数据模型
        weatherData.value = _convertWeatherData(weatherKitData);
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
        locationName.value = weatherKitData.location.name;
      },
      (error) {
        errorMessage.value = '获取天气数据失败: ${error.message}';
      },
    );
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
      final poem = _poetryService.getRandomPoem();
      return _convertPoemData(poem);
    }

    // 如果是节气当天，优先显示节气诗词
    if (isSolarTermDay.value && currentSolarTerm.value.isNotEmpty) {
      final poem = _poetryService.getPoem(solarTerm: currentSolarTerm.value);
      if (poem != null) {
        return _convertPoemData(poem);
      }
    }

    // 根据天气状况获取诗词
    final poem = _poetryService.getPoem(
      weatherCondition: weatherData.value!.current.condition.text,
      season: currentSeason.value,
    );

    return _convertPoemData(poem ?? _poetryService.getRandomPoem()!);
  }

  /// 转换 ChinesePoetryKit 数据到 ZenWeather 数据模型
  PoemData _convertPoemData(poetry_kit.Poem poem) {
    return PoemData(
      title: poem.title,
      author: poem.author,
      dynasty: poem.dynasty,
      content: poem.content.join('\n'),
      tags: poem.tags,
    );
  }

  /// 获取节气描述（使用 SolarTermKit）
  String getSolarTermDescription() {
    if (currentSolarTerm.value.isEmpty) return '';

    final solarTerm = solar_term_kit.SolarTerms.getSolarTermByName(currentSolarTerm.value);
    return solarTerm?.description ?? '';
  }

  /// 获取当前温度
  int get currentTemp {
    return weatherData.value?.current.tempC.round() ?? 0;
  }

  /// 获取天气描述
  String get weatherDesc {
    return weatherData.value?.current.condition.text ?? '未知';
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
