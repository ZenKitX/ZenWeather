import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/zen_colors.dart';
import '../../../components/city_card.dart';
import '../../../components/loading_widget.dart';
import '../controllers/cities_controller.dart';
import 'city_search_view.dart';

/// 城市管理页面
class CitiesView extends GetView<CitiesController> {
  const CitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('城市管理'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CitySearchView()),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: '加载城市中...');
        }

        if (controller.cities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_city_outlined,
                  size: 80.sp,
                  color: ZenColors.darkMist,
                ),
                SizedBox(height: 24.h),
                Text(
                  '还没有添加城市',
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const CitySearchView()),
                  icon: const Icon(Icons.add),
                  label: const Text('添加城市'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZenColors.bambooGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshCities,
          child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: controller.cities.length,
            itemBuilder: (context, index) {
              final city = controller.cities[index];
              return CityCard(
                city: city,
                onTap: () => _showCityOptions(context, city),
                onDelete: () => _showDeleteDialog(context, index),
              );
            },
          ),
        );
      }),
    );
  }

  /// 显示城市选项
  void _showCityOptions(BuildContext context, city) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('切换到此城市'),
              onTap: () {
                Get.back();
                controller.switchToCity(city);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('查看详情'),
              onTap: () {
                Get.back();
                Get.toNamed('/weather-detail', arguments: city.name);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('删除城市'),
        content: Text('确定要删除 ${controller.cities[index].name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeCity(index);
            },
            child: Text(
              '删除',
              style: TextStyle(color: ZenColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
