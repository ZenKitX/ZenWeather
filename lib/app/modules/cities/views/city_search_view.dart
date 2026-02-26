import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/city_card.dart';
import '../../../components/loading_widget.dart';
import '../controllers/cities_controller.dart';

/// 城市搜索页面
class CitySearchView extends GetView<CitiesController> {
  const CitySearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索城市...',
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          onChanged: (value) {
            controller.searchCities(value);
          },
        ),
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return const LoadingWidget(message: '搜索中...');
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 80.sp,
                  color: theme.iconTheme.color?.withOpacity(0.3),
                ),
                SizedBox(height: 24.h),
                Text(
                  '输入城市名称搜索',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final city = controller.searchResults[index];
            return SearchCityCard(
              city: city,
              onTap: () => controller.addCity(city),
            );
          },
        );
      }),
    );
  }
}
