import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// 设置绑定
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
