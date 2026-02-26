import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme/zen_colors.dart';
import '../data/local/poem_database.dart';

/// 诗词卡片组件
class PoemCard extends StatelessWidget {
  final PoemData poem;
  final VoidCallback? onTap;

  const PoemCard({
    Key? key,
    required this.poem,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
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
          // 水墨边框效果
          border: Border.all(
            color: isDark 
                ? ZenColors.darkMist.withOpacity(0.3)
                : ZenColors.mistGray.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // 引号图标
            Icon(
              Icons.format_quote,
              size: 32.sp,
              color: ZenColors.bambooGreen.withOpacity(0.5),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 1000.ms)
                .then()
                .shimmer(duration: 2000.ms, color: ZenColors.bambooGreen.withOpacity(0.3)),
            
            SizedBox(height: 16.h),
            
            // 诗词内容
            Text(
              poem.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18.sp,
                height: 1.8,
                letterSpacing: 2,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 20.h),
            
            // 分隔线
            Container(
              width: 60.w,
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    ZenColors.bambooGreen.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 作者信息
            Text(
              poem.fullInfo,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 节气诗词卡片
class SolarTermPoemCard extends StatelessWidget {
  final String solarTerm;
  final PoemData poem;
  final String description;

  const SolarTermPoemCard({
    Key? key,
    required this.solarTerm,
    required this.poem,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ZenColors.bambooGreen.withOpacity(0.1),
            ZenColors.plumBlossom.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ZenColors.bambooGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // 节气标题
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wb_twilight,
                size: 24.sp,
                color: ZenColors.bambooGreen,
              ),
              SizedBox(width: 8.w),
              Text(
                '今日节气·$solarTerm',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: ZenColors.bambooGreen,
                ),
              ),
            ],
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(duration: 1000.ms)
              .then()
              .scale(duration: 1500.ms, begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05)),
          
          SizedBox(height: 12.h),
          
          // 节气描述
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              letterSpacing: 1,
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // 诗词内容
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  poem.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    height: 1.8,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  poem.fullInfo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 简约诗词卡片
class MinimalPoemCard extends StatelessWidget {
  final String content;
  final String? author;

  const MinimalPoemCard({
    Key? key,
    required this.content,
    this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              height: 1.6,
              letterSpacing: 1.5,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          if (author != null) ...[
            SizedBox(height: 8.h),
            Text(
              '—— $author',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
