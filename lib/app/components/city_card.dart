import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme/zen_colors.dart';
import '../data/models/city_model.dart';

/// 城市卡片组件
class CityCard extends StatelessWidget {
  final CityModel city;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CityCard({
    Key? key,
    required this.city,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 天气图标
            if (city.weatherIcon != null)
              CachedNetworkImage(
                imageUrl: 'https:${city.weatherIcon}',
                width: 60.w,
                height: 60.h,
                placeholder: (context, url) => SizedBox(
                  width: 60.w,
                  height: 60.h,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.cloud,
                  size: 60.sp,
                  color: ZenColors.bambooGreen,
                ),
              )
            else
              Icon(
                Icons.location_city,
                size: 60.sp,
                color: ZenColors.bambooGreen,
              ),

            SizedBox(width: 16.w),

            // 城市信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    city.region.isNotEmpty ? city.region : city.country,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  if (city.weatherCondition != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      city.weatherCondition!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: ZenColors.bambooGreen,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 温度和删除按钮
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (city.currentTemp != null)
                  Text(
                    city.currentTemp!,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                if (onDelete != null) ...[
                  SizedBox(height: 8.h),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: ZenColors.error,
                      size: 20.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 搜索结果城市卡片
class SearchCityCard extends StatelessWidget {
  final CityModel city;
  final VoidCallback onTap;

  const SearchCityCard({
    Key? key,
    required this.city,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Icon(
        Icons.location_on,
        color: ZenColors.bambooGreen,
        size: 24.sp,
      ),
      title: Text(
        city.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        city.fullAddress,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: Icon(
        Icons.add_circle_outline,
        color: ZenColors.bambooGreen,
        size: 24.sp,
      ),
    );
  }
}
