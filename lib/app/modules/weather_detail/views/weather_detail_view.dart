import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/zen_colors.dart';
import '../../../components/loading_widget.dart';
import '../../../components/error_widget.dart';
import '../controllers/weather_detail_controller.dart';

/// 天气详情视图
class WeatherDetailView extends GetView<WeatherDetailController> {
  const WeatherDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.weather.value?.location.name ?? '天气详情',
        )),
        centerTitle: true,
      ),
      body: Obx(() {
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
        
        // 无数据
        if (controller.weather.value == null) {
          return const Center(child: Text('暂无数据'));
        }
        
        final weather = controller.weather.value!;
        
        return RefreshIndicator(
          onRefresh: controller.refreshWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 当前天气概览
                _buildCurrentWeatherCard(theme, weather)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 24.h),
                
                // 24小时预报
                _buildSectionTitle(theme, '24小时预报')
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms),
                
                SizedBox(height: 12.h),
                
                _buildHourlyForecast(theme, weather)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideX(begin: 0.1, end: 0),
                
                SizedBox(height: 24.h),
                
                // 7天预报
                _buildSectionTitle(theme, '7天预报')
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms),
                
                SizedBox(height: 12.h),
                
                _buildDailyForecast(theme, weather)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 构建当前天气卡片
  Widget _buildCurrentWeatherCard(ThemeData theme, weather) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ZenColors.bambooGreen.withOpacity(0.1),
            ZenColors.skyBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ZenColors.bambooGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 温度
          Text(
            '${weather.current.tempC.round()}°',
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 64.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // 天气状况
          Text(
            weather.current.conditionText,
            style: theme.textTheme.displaySmall,
          ),
          
          SizedBox(height: 4.h),
          
          // 体感温度
          Text(
            '体感 ${weather.current.feelslikeC.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // 详细信息网格
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherInfo(
                theme,
                Icons.water_drop_outlined,
                '湿度',
                '${weather.current.humidity}%',
              ),
              _buildWeatherInfo(
                theme,
                Icons.air,
                '风速',
                '${weather.current.windKph.toStringAsFixed(1)} km/h',
              ),
              _buildWeatherInfo(
                theme,
                Icons.visibility_outlined,
                '能见度',
                '${weather.current.visKm.toStringAsFixed(1)} km',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建天气信息项
  Widget _buildWeatherInfo(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: ZenColors.bambooGreen),
        SizedBox(height: 8.h),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建章节标题
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.displaySmall?.copyWith(
        fontSize: 18.sp,
      ),
    );
  }

  /// 构建24小时预报
  Widget _buildHourlyForecast(ThemeData theme, weather) {
    if (weather.hourly.isEmpty) {
      return const Center(child: Text('暂无小时预报'));
    }
    
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weather.hourly.length > 24 ? 24 : weather.hourly.length,
        itemBuilder: (context, index) {
          final hour = weather.hourly[index];
          return _buildHourlyItem(theme, hour);
        },
      ),
    );
  }

  /// 构建小时预报项
  Widget _buildHourlyItem(ThemeData theme, hourly) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ZenColors.bambooGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 时间
          Text(
            hourly.time.split(' ')[1],
            style: theme.textTheme.bodySmall,
          ),
          
          SizedBox(height: 8.h),
          
          // 天气图标
          Image.network(
            'https:${hourly.icon}',
            width: 32.w,
            height: 32.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.cloud,
                size: 32.w,
                color: ZenColors.bambooGreen,
              );
            },
          ),
          
          SizedBox(height: 8.h),
          
          // 温度
          Text(
            '${hourly.tempC.round()}°',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建7天预报
  Widget _buildDailyForecast(ThemeData theme, weather) {
    if (weather.daily.isEmpty) {
      return const Center(child: Text('暂无每日预报'));
    }
    
    return Column(
      children: weather.daily.map((day) {
        return _buildDailyItem(theme, day);
      }).toList(),
    );
  }

  /// 构建每日预报项
  Widget _buildDailyItem(ThemeData theme, daily) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ZenColors.bambooGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 日期
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(daily.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _getWeekday(daily.date),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          // 天气图标
          Image.network(
            'https:${daily.icon}',
            width: 40.w,
            height: 40.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.cloud,
                size: 40.w,
                color: ZenColors.bambooGreen,
              );
            },
          ),
          
          SizedBox(width: 16.w),
          
          // 天气描述
          Expanded(
            flex: 2,
            child: Text(
              daily.conditionText,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // 温度范围
          Text(
            '${daily.minTempC.round()}° / ${daily.maxTempC.round()}°',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化日期
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.month}月${date.day}日';
  }

  /// 获取星期
  String _getWeekday(String dateStr) {
    final date = DateTime.parse(dateStr);
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[date.weekday - 1];
  }
}
