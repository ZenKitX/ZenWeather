import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/local/storage_service.dart';

/// 启动页控制器
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  /// 延迟跳转到首页
  void _navigateToHome() async {
    // 等待2秒，展示启动页
    await Future.delayed(const Duration(seconds: 2));
    
    // 检查是否首次启动
    bool isFirst = StorageService.isFirstLaunch();
    
    if (isFirst) {
      // 标记已启动过
      await StorageService.setFirstLaunch(false);
    }
    
    // 跳转到首页
    Get.offAllNamed(AppRoutes.home);
  }
}
