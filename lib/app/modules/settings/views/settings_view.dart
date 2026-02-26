import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/zen_colors.dart';
import '../controllers/settings_controller.dart';

/// 设置页面
class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionHeader('外观设置', theme),
          Obx(() => SwitchListTile(
            title: const Text('深色模式'),
            subtitle: const Text('切换浅色/深色主题'),
            value: !controller.isLightTheme.value,
            onChanged: (value) => controller.toggleTheme(),
            activeColor: ZenColors.bambooGreen,
          )),

          const Divider(),

          // 单位设置
          _buildSectionHeader('单位设置', theme),
          Obx(() => SwitchListTile(
            title: const Text('温度单位'),
            subtitle: Text(controller.isCelsius.value ? '摄氏度 (℃)' : '华氏度 (℉)'),
            value: controller.isCelsius.value,
            onChanged: (value) => controller.toggleTemperatureUnit(),
            activeColor: ZenColors.bambooGreen,
          )),

          const Divider(),

          // 语言设置
          _buildSectionHeader('语言设置', theme),
          ListTile(
            title: const Text('语言'),
            subtitle: Obx(() => Text(
              controller.languageCode.value == 'zh' ? '简体中文' : 'English',
            )),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),

          const Divider(),

          // 数据管理
          _buildSectionHeader('数据管理', theme),
          ListTile(
            title: const Text('清除缓存'),
            subtitle: const Text('清除图片和数据缓存'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(),
          ),

          const Divider(),

          // 关于
          _buildSectionHeader('关于', theme),
          ListTile(
            title: const Text('关于禅意天气'),
            subtitle: const Text('版本 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => controller.showAbout(),
          ),
          ListTile(
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.snackbar('提示', '隐私政策页面开发中'),
          ),
          ListTile(
            title: const Text('用户协议'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.snackbar('提示', '用户协议页面开发中'),
          ),

          SizedBox(height: 40.h),

          // 版权信息
          Center(
            child: Text(
              '© 2026 禅意天气\n感受天气的诗意',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ZenColors.darkMist,
              ),
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  /// 构建分组标题
  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: ZenColors.bambooGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 显示语言选择对话框
  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('简体中文'),
              value: 'zh',
              groupValue: controller.languageCode.value,
              onChanged: (value) {
                if (value != null) {
                  controller.changeLanguage(value);
                  Get.back();
                }
              },
              activeColor: ZenColors.bambooGreen,
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: controller.languageCode.value,
              onChanged: (value) {
                if (value != null) {
                  controller.changeLanguage(value);
                  Get.back();
                }
              },
              activeColor: ZenColors.bambooGreen,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示清除缓存确认对话框
  void _showClearCacheDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearCache();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
