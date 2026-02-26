import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../../config/theme/zen_theme.dart';

/// 设置控制器
class SettingsController extends GetxController {
  // 主题模式
  final RxBool isLightTheme = true.obs;
  
  // 温度单位 (true: 摄氏度, false: 华氏度)
  final RxBool isCelsius = true.obs;
  
  // 语言
  final RxString languageCode = 'zh'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// 加载设置
  void _loadSettings() {
    isLightTheme.value = StorageService.getThemeMode();
    languageCode.value = StorageService.getLanguageCode();
    // 温度单位默认摄氏度
    isCelsius.value = true;
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

  /// 切换温度单位
  void toggleTemperatureUnit() {
    isCelsius.value = !isCelsius.value;
    // TODO: 保存到本地存储
  }

  /// 切换语言
  void changeLanguage(String code) {
    languageCode.value = code;
    StorageService.setLanguageCode(code);
    // TODO: 实现多语言切换
    Get.snackbar('提示', '语言切换功能开发中');
  }

  /// 清除缓存
  Future<void> clearCache() async {
    // TODO: 实现清除缓存
    Get.snackbar('成功', '缓存已清除');
  }

  /// 关于应用
  void showAbout() {
    Get.dialog(
      const AboutDialog(),
    );
  }
}

/// 关于对话框
class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('关于禅意天气'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('版本：1.0.0'),
          SizedBox(height: 8),
          Text('一个充满禅意的天气应用'),
          SizedBox(height: 8),
          Text('融合中国传统文化元素'),
          SizedBox(height: 8),
          Text('感受天气的诗意'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
