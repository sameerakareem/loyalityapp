import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:posibolt_loyality/themes/themeclass.dart';


class LoadingCircle extends StatefulWidget {
  double? size = 25;
  Color? color = ThemeClass.primaryColor;
  final Color ringColor;

  LoadingCircle({
    Key? key,
    this.size,
    this.color,
    this.ringColor = const Color(0x1A000000),
  }) : super(key: key);

  @override
  _LoadingCircleState createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size ?? 25;
    final Color color = widget.color ??ThemeClass.primaryColor;
    final Color ringColor = widget.ringColor;
    final double strokeWidth = size / 5;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Arc.draw(
              strokeWidth: strokeWidth,
              size: size,
              color: ringColor,
              startAngle: math.pi / 2,
              endAngle: 2 * math.pi,
            ),
            Visibility(
              visible: _animationController.value <= 0.9,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: Offset(0, -size),
                  end: Offset.zero,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.05,
                          0.4,
                          curve: Curves.easeInCubic,
                        ),
                      ),
                    )
                    .value,
                child: Arc.draw(
                  strokeWidth: strokeWidth,
                  size: size,
                  color: color,
                  startAngle: -3 * math.pi / 2,
                  // endAngle: math.pi / (size * size),
                  endAngle: Tween<double>(
                    begin: math.pi / (size * size),
                    end: math.pi / 1.13,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(
                            0.38,
                            0.9,
                          ),
                        ),
                      )
                      .value,
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.9,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: Offset(0, -size),
                  end: Offset.zero,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.05,
                          0.4,
                          curve: Curves.easeInCubic,
                        ),
                      ),
                    )
                    .value,
                child: Arc.draw(
                  strokeWidth: strokeWidth,
                  size: size,
                  color: color,
                  startAngle: -3 * math.pi / 2,
                  endAngle: Tween<double>(
                    begin: math.pi / (size * size),
                    end: -math.pi / 1.13,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(
                            0.38,
                            0.9,
                          ),
                        ),
                      )
                      .value,
                ),
              ),
            ),

            /// Right
            Visibility(
              visible: _animationController.value >= 0.9,
              child: Arc.draw(
                strokeWidth: strokeWidth,
                size: size,
                color: color,
                startAngle: -math.pi / 4,
                endAngle: Tween<double>(
                  begin: -math.pi / 7.4,
                  end: -math.pi / 4,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.9,
                          0.96,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
            // Left
            Visibility(
              visible: _animationController.value >= 0.9,
              child: Arc.draw(
                strokeWidth: strokeWidth,
                size: size,
                color: color,
                startAngle: -3 * math.pi / 4,
                // endAngle: math.pi / 4
                // endAngle: math.pi / 7.4
                endAngle: Tween<double>(
                  begin: math.pi / 7.4,
                  end: math.pi / 4,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.9,
                          0.96,
                        ),
                      ),
                    )
                    .value,
              ),
            ),

            /// Right
            Visibility(
              visible: _animationController.value >= 0.9,
              child: Arc.draw(
                strokeWidth: strokeWidth,
                size: size,
                color: color,
                startAngle: -math.pi / 3.5,
                // endAngle: math.pi / 28,
                endAngle: Tween<double>(
                  begin: math.pi / 1.273,
                  end: math.pi / 28,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.9,
                          1.0,
                        ),
                      ),
                    )
                    .value,
              ),
            ),

            /// Left
            Visibility(
              visible: _animationController.value >= 0.9,
              child: Arc.draw(
                strokeWidth: strokeWidth,
                size: size,
                color: color,
                startAngle: math.pi / 0.778,
                // endAngle: -math.pi / 1.273
                // endAngle: -math.pi / 27

                endAngle: Tween<double>(
                  begin: -math.pi / 1.273,
                  end: -math.pi / 27,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.9,
                          1.0,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Arc extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  Arc._(
    this._color,
    this._strokeWidth,
    this._startAngle,
    this._sweepAngle,
  );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
