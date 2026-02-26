import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/zen_colors.dart';
import '../../../components/loading_widget.dart';
import '../../../components/error_widget.dart';
import '../../../components/poem_card.dart';
import '../../../components/weather_animation.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

/// 首页视图
class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // 加载状态
          if (controller.isLoading.value) {
            return const ShimmerLoading();
          }
          
          // 错误状态
          if (controller.errorMessage.value.isNotEmpty) {
            return ErrorDisplayWidget(
              message: controller.errorMessage.value,
              onRetry: controller.refreshWeather,
            );
          }
          
          // 正常显示
          return RefreshIndicator(
            onRefresh: controller.refreshWeather,
            child: CustomScrollView(
              slivers: [
                // 顶部栏
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 位置信息
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Get.toNamed(AppRoutes.cities);
                              if (result != null) {
                                // 切换到选中的城市
                                controller.refreshWeather();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20.sp,
                                  color: theme.iconTheme.color,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Obx(() => Text(
                                    controller.locationName.value,
                                    style: theme.textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20.sp,
                                  color: theme.iconTheme.color,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // 设置按钮
                        IconButton(
                          onPressed: () => Get.toNamed(AppRoutes.settings),
                          icon: const Icon(Icons.settings_outlined),
                        ),
                        
                        // 主题切换按钮
                        Obx(() => IconButton(
                          onPressed: controller.toggleTheme,
                          icon: Icon(
                            controller.isLightTheme.value
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                          ),
                        )),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                  ),
                ),
              
                
                // 主要内容
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        
                        // 天气动画
                        GestureDetector(
                          onTap: () {
                            // 跳转到天气详情页
                            Get.toNamed(
                              AppRoutes.weatherDetail,
                              arguments: controller.locationName.value,
                            );
                          },
                          child: Obx(() => WeatherAnimation(
                            weatherType: controller.weatherDesc,
                            height: 200.h,
                          ))
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 600.ms),
                        ),
                        
                        // 温度显示
                        Obx(() => Text(
                          '${controller.currentTemp}°',
                          style: theme.textTheme.displayLarge,
                        ))
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 600.ms)
                            .scale(delay: 200.ms),
                        
                        SizedBox(height: 16.h),
                        
                        // 天气描述
                        Obx(() => Text(
                          controller.weatherDesc,
                          style: theme.textTheme.displaySmall,
                        ))
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms),
                        
                        SizedBox(height: 12.h),
                        
                        // 季节标签
                        Obx(() => _buildSeasonTag(theme))
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 600.ms),
                        
                        SizedBox(height: 40.h),
                        
                        // 节气诗词卡片（如果是节气当天）
                        Obx(() {
                          if (controller.isSolarTermDay.value) {
                            return SolarTermPoemCard(
                              solarTerm: controller.currentSolarTerm.value,
                              poem: controller.getPoemByWeather(),
                              description: controller.getSolarTermDescription(),
                            )
                                .animate()
                                .fadeIn(delay: 600.ms, duration: 600.ms)
                                .slideY(begin: 0.2, end: 0);
                          }
                          return const SizedBox.shrink();
                        }),
                        
                        if (controller.isSolarTermDay.value) SizedBox(height: 40.h),
                        
                        // 普通诗词卡片
                        Obx(() => PoemCard(
                          poem: controller.getPoemByWeather(),
                        ))
                            .animate()
                            .fadeIn(delay: 700.ms, duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        
                        SizedBox(height: 40.h),
                        
                        // 天气详情卡片
                        _buildWeatherDetailsCard(theme)
                            .animate()
                            .fadeIn(delay: 800.ms, duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 构建季节标签
  Widget _buildSeasonTag(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: controller.seasonalColors.value?.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: controller.seasonalColors.value?.primary ?? ZenColors.bambooGreen,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSeasonIcon(controller.currentSeason.value),
            size: 16.sp,
            color: controller.seasonalColors.value?.primary,
          ),
          SizedBox(width: 6.w),
          Text(
            '${controller.currentSeason.value}季',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: controller.seasonalColors.value?.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 获取季节图标
  IconData _getSeasonIcon(String season) {
    switch (season) {
      case '春':
        return Icons.local_florist;
      case '夏':
        return Icons.wb_sunny;
      case '秋':
        return Icons.eco;
      case '冬':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }

  /// 构建天气详情卡片
  Widget _buildWeatherDetailsCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '天气详情',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => _buildDetailRow(
            theme, 
            Icons.water_drop_outlined, 
            '湿度', 
            '${controller.humidity}%',
          )),
          SizedBox(height: 16.h),
          Obx(() => _buildDetailRow(
            theme, 
            Icons.air, 
            '风速', 
            '${controller.windSpeed.toStringAsFixed(1)} km/h',
          )),
          SizedBox(height: 16.h),
          Obx(() => _buildDetailRow(
            theme, 
            Icons.visibility_outlined, 
            '能见度', 
            '${controller.visibility.toStringAsFixed(1)} km',
          )),
          SizedBox(height: 16.h),
          Obx(() => _buildDetailRow(
            theme, 
            Icons.compress, 
            '气压', 
            '${controller.pressure.toStringAsFixed(0)} hPa',
          )),
        ],
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: ZenColors.bambooGreen),
        SizedBox(width: 12.w),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
