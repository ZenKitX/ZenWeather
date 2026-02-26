import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/zen_theme.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await StorageService.init();

  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ZenWeatherApp());
}

class ZenWeatherApp extends StatelessWidget {
  const ZenWeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取保存的主题模式
    final isLightTheme = StorageService.getThemeMode();

    return ScreenUtilInit(
      designSize: const Size(390, 844), // 设计稿尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: '禅意天气',
          debugShowCheckedModeBanner: false,
          
          // 主题配置
          theme: ZenTheme.getThemeData(isLight: true),
          darkTheme: ZenTheme.getThemeData(isLight: false),
          themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
          
          // 路由配置
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          
          // 默认过渡动画
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
