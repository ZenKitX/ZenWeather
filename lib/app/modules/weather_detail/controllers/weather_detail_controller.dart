import 'package:get/get.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/weather_service.dart';

/// 天气详情控制器
class WeatherDetailController extends GetxController {
  final WeatherService _weatherService = WeatherService();

  // 天气数据
  final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);
  
  // 加载状态
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // 城市名称
  late String cityName;

  @override
  void onInit() {
    super.onInit();
    // 从路由参数获取城市名称
    cityName = Get.arguments as String? ?? '';
    if (cityName.isNotEmpty) {
      loadWeatherDetail();
    }
  }

  /// 加载天气详情
  Future<void> loadWeatherDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _weatherService.getWeatherByCity(cityName);
      if (result != null) {
        weather.value = result;
      } else {
        errorMessage.value = '获取天气数据失败';
      }
    } catch (e) {
      errorMessage.value = '网络错误：${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// 刷新天气
  Future<void> refreshWeather() async {
    await loadWeatherDetail();
  }
}
