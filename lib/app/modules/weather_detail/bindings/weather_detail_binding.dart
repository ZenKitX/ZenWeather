import 'package:get/get.dart';
import '../controllers/weather_detail_controller.dart';

/// 天气详情绑定
class WeatherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherDetailController>(
      () => WeatherDetailController(),
    );
  }
}
