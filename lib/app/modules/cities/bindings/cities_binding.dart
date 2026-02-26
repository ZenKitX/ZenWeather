import 'package:get/get.dart';
import '../controllers/cities_controller.dart';

/// 城市管理绑定
class CitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitiesController>(() => CitiesController());
  }
}
