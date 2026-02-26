import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../config/theme/zen_colors.dart';
import '../controllers/splash_controller.dart';

/// 启动页视图
class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 应用图标
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ZenColors.bambooGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.cloud_outlined,
                size: 60,
                color: ZenColors.bambooGreen,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 400.ms),
            
            const SizedBox(height: 32),
            
            // 应用名称
            Text(
              '禅意天气',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 8,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 8),
            
            // 副标题
            Text(
              '感受天气的诗意',
              style: theme.textTheme.bodyMedium?.copyWith(
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
