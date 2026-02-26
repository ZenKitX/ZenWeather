import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 天气动画组件
class WeatherAnimation extends StatefulWidget {
  final String weatherType;
  final double width;
  final double height;

  const WeatherAnimation({
    Key? key,
    required this.weatherType,
    this.width = double.infinity,
    this.height = 300,
  }) : super(key: key);

  @override
  State<WeatherAnimation> createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherType = widget.weatherType.toLowerCase();

    if (weatherType.contains('雨') || weatherType.contains('rain')) {
      return _buildRainAnimation();
    } else if (weatherType.contains('雪') || weatherType.contains('snow')) {
      return _buildSnowAnimation();
    } else if (weatherType.contains('云') || weatherType.contains('cloud')) {
      return _buildCloudAnimation();
    } else if (weatherType.contains('晴') || weatherType.contains('sunny')) {
      return _buildSunnyAnimation();
    }

    return const SizedBox.shrink();
  }

  /// 雨天动画
  Widget _buildRainAnimation() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: RainPainter(
              animation: _controller.value,
            ),
          );
        },
      ),
    );
  }

  /// 雪天动画
  Widget _buildSnowAnimation() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SnowPainter(
              animation: _controller.value,
            ),
          );
        },
      ),
    );
  }

  /// 云天动画
  Widget _buildCloudAnimation() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: CloudPainter(
              animation: _controller.value,
            ),
          );
        },
      ),
    );
  }

  /// 晴天动画
  Widget _buildSunnyAnimation() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SunnyPainter(
              animation: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

/// 雨滴画笔
class RainPainter extends CustomPainter {
  final double animation;
  final math.Random random = math.Random(42);

  RainPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // 绘制20个雨滴
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final y = (baseY + animation * size.height) % size.height;
      final length = 20.0 + random.nextDouble() * 10;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) => true;
}

/// 雪花画笔
class SnowPainter extends CustomPainter {
  final double animation;
  final math.Random random = math.Random(42);

  SnowPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // 绘制15个雪花
    for (int i = 0; i < 15; i++) {
      final x = (random.nextDouble() * size.width + animation * 50) % size.width;
      final baseY = random.nextDouble() * size.height;
      final y = (baseY + animation * size.height * 0.5) % size.height;
      final radius = 3.0 + random.nextDouble() * 3;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => true;
}

/// 云朵画笔
class CloudPainter extends CustomPainter {
  final double animation;

  CloudPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // 绘制3朵云
    for (int i = 0; i < 3; i++) {
      final x = (size.width * 0.2 * i + animation * size.width * 0.3) % size.width;
      final y = size.height * 0.2 + i * 30.0;

      _drawCloud(canvas, Offset(x, y), paint);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 20, paint);
    canvas.drawCircle(center + const Offset(15, -5), 25, paint);
    canvas.drawCircle(center + const Offset(30, 0), 20, paint);
    canvas.drawCircle(center + const Offset(20, 10), 18, paint);
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) => true;
}

/// 太阳画笔
class SunnyPainter extends CustomPainter {
  final double animation;

  SunnyPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.3);
    final radius = 40.0;

    // 太阳光晕
    final glowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius + 20, glowPaint);

    // 太阳本体
    final sunPaint = Paint()
      ..color = Colors.orange.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sunPaint);

    // 太阳光线
    final rayPaint = Paint()
      ..color = Colors.orange.withOpacity(0.4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 + animation * 360) * math.pi / 180;
      final startX = center.dx + math.cos(angle) * (radius + 10);
      final startY = center.dy + math.sin(angle) * (radius + 10);
      final endX = center.dx + math.cos(angle) * (radius + 25);
      final endY = center.dy + math.sin(angle) * (radius + 25);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(SunnyPainter oldDelegate) => true;
}
