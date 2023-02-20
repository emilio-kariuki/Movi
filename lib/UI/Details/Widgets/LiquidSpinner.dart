
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math; 

class LiquidSpinner extends StatelessWidget {
  final double height;
  final int time;
  final int timeWait;
  final double pad;
  final double diameter;

  const LiquidSpinner(
      {Key ?key,
      required this.height,
      required this.time,
      this.pad = 30.0,
      this.diameter = 200.0,
      this.timeWait = 30})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: pad),
      height: height,
      child: AutomatedAnimator(
        timeDispose: timeWait,
        animateToggle: true,
        doRepeatAnimation: true,
        duration: Duration(seconds: time),
        buildWidget: (double animationPosition) {
          return WaveLoadingBubble(
            bubbleDiameter: diameter,
            foregroundWaveColor: Color(0xFF00BFF3),
            backgroundWaveColor: Color(0xFF92DEF3),
            loadingWheelColor: Color(0xFF00BFF3),
            period: animationPosition,
            backgroundWaveVerticalOffset: 90 - animationPosition * 200,
            foregroundWaveVerticalOffset: 90 +
                reversingSplitParameters(
                  position: animationPosition,
                  numberBreaks: 6,
                  parameterBase: 8.0,
                  parameterVariation: 8.0,
                  reversalPoint: 0.75,
                ) -
                animationPosition * 200,
            waveHeight: reversingSplitParameters(
              position: animationPosition,
              numberBreaks: 5,
              parameterBase: 12,
              parameterVariation: 8,
              reversalPoint: 0.75,
            ),
          );
        },
      ),
    );
  }
}


class AutomatedAnimator extends StatefulWidget {
  AutomatedAnimator({
    required this.buildWidget,
    required this.animateToggle,
    this.duration = const Duration(milliseconds: 300),
    this.doRepeatAnimation = false,
    Key ?key,
    this.timeDispose = 15,
  }) : super(key: key);

  final Widget Function(double animationValue) buildWidget;
  final Duration duration;
  final int timeDispose;
  final bool animateToggle;
  final bool doRepeatAnimation;

  @override
  _AutomatedAnimatorState createState() => _AutomatedAnimatorState();
}

class _AutomatedAnimatorState extends State<AutomatedAnimator>
    with SingleTickerProviderStateMixin {
 
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}));
    if (widget.animateToggle == true) controller.forward();
    if (widget.doRepeatAnimation == true) controller.repeat();
    // Future.delayed(Duration(seconds: widget.timeDispose), () {
    //   controller.dispose();
    // });
  }

  @override
  void didUpdateWidget(AutomatedAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateToggle == true) {
      controller.forward();
      return;
    }
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
         }

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(controller.value);
  }
}

double reversingSplitParameters({
  required double position,
  required double numberBreaks,
  required double parameterBase,
  required double parameterVariation,
  required double reversalPoint,
}) {
  assert(reversalPoint <= 1.0 && reversalPoint >= 0.0,
      "reversalPoint must be a number between 0.0 and 1.0");
  final double finalAnimationPosition =
      breakAnimationPosition(position, numberBreaks);

  if (finalAnimationPosition <= 0.5) {
    return parameterBase - (finalAnimationPosition * 2 * parameterVariation);
  } else {
    return parameterBase -
        ((1 - finalAnimationPosition) * 2 * parameterVariation);
  }
}

double breakAnimationPosition(double position, double numberBreaks) {
  double finalAnimationPosition = 0;
  final double breakPoint = 1.0 / numberBreaks;

  for (var i = 0; i < numberBreaks; i++) {
    if (position <= breakPoint * (i + 1)) {
      finalAnimationPosition = (position - i * breakPoint) * numberBreaks;
      break;
    }
  }

  return finalAnimationPosition;
}


class WaveLoadingBubble extends StatelessWidget {
  const WaveLoadingBubble({
    this.bubbleDiameter = 200.0,
    this.loadingCircleWidth = 10.0,
    this.waveInsetWidth = 5.0,
    this.waveHeight = 10.0,
    this.foregroundWaveColor = Colors.lightBlue,
    this.backgroundWaveColor = Colors.blue,
    this.loadingWheelColor = Colors.white,
    this.foregroundWaveVerticalOffset = 10.0,
    this.backgroundWaveVerticalOffset = 0.0,
    this.period = 0.0,
    Key ?key,
  }) : super(key: key);

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveLoadingBubblePainter(
        bubbleDiameter: bubbleDiameter,
        loadingCircleWidth: loadingCircleWidth,
        waveInsetWidth: waveInsetWidth,
        waveHeight: waveHeight,
        foregroundWaveColor: foregroundWaveColor,
        backgroundWaveColor: backgroundWaveColor,
        loadingWheelColor: loadingWheelColor,
        foregroundWaveVerticalOffset: foregroundWaveVerticalOffset,
        backgroundWaveVerticalOffset: backgroundWaveVerticalOffset,
        period: period,
      ),
    );
  }
}

class WaveLoadingBubblePainter extends CustomPainter {
  WaveLoadingBubblePainter({
    required this.bubbleDiameter,
    required this.loadingCircleWidth,
    required this.waveInsetWidth,
    required this.waveHeight,
    required this.foregroundWaveColor,
    required this.backgroundWaveColor,
    required this.loadingWheelColor,
    required this.foregroundWaveVerticalOffset,
    required this.backgroundWaveVerticalOffset,
    required this.period,
  })  : foregroundWavePaint = Paint()..color = foregroundWaveColor,
        backgroundWavePaint = Paint()..color = backgroundWaveColor,
        loadingCirclePaint = Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              loadingWheelColor,
              Colors.transparent,
            ],
            stops: [0.0, 0.9, 1.0],
            startAngle: 0,
            endAngle: math.pi * 1,
            transform: GradientRotation(period * math.pi * 2 * 5),
          ).createShader(Rect.fromCircle(
            center: Offset(0.0, 0.0),
            radius: bubbleDiameter / 2,
          ));

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Paint foregroundWavePaint;
  final Paint backgroundWavePaint;
  final Paint loadingCirclePaint;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  void paint(Canvas canvas, Size size) {
    final double loadingBubbleRadius = (bubbleDiameter / 2);
    final double insetBubbleRadius = loadingBubbleRadius - waveInsetWidth;
    final double waveBubbleRadius = insetBubbleRadius - loadingCircleWidth;

    Path backgroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint:
          Offset(0.0 - waveBubbleRadius, 0.0 + backgroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: period * 2 * 5,
    ).build();

    Path foregroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint:
          Offset(0.0 - waveBubbleRadius, 0.0 + foregroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: -period * 2 * 5,
    ).build();

    Path circleClip = Path()
      ..addRRect(RRect.fromLTRBXY(
          -waveBubbleRadius,
          -waveBubbleRadius,
          waveBubbleRadius,
          waveBubbleRadius,
          waveBubbleRadius,
          waveBubbleRadius));

    //Path insetCirclePath = Path()..addRRect(RRect.fromLTRBXY(-insetBubbleRadius, -insetBubbleRadius, insetBubbleRadius, insetBubbleRadius, insetBubbleRadius, insetBubbleRadius));
    //Path loadingCirclePath = Path()..addRRect(RRect.fromLTRBXY(-loadingBubbleRadius, -loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius));

    // canvas.drawPath(Path.combine(PathOperation.difference, loadingCirclePath, insetCirclePath), loadingCirclePaint);
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(backgroundWavePath, backgroundWavePaint);
    canvas.drawPath(foregroundWavePath, foregroundWavePaint);
  }

  @override
  bool shouldRepaint(WaveLoadingBubblePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(WaveLoadingBubblePainter oldDelegate) => false;
}

class WavePathHorizontal {
  WavePathHorizontal({
    required this.width,
    required this.amplitude,
    required this.period,
    required this.startPoint,
    this.phaseShift = 0.0,
    this.doClosePath = false,
    this.crossAxisEndPoint = 0,
  }) : assert(crossAxisEndPoint != null || doClosePath == false,
            "if doClosePath is true you must provide an end point (crossAxisEndPoint)");

  final double width;
  final double amplitude;
  final double period;
  final Offset startPoint;
  final double crossAxisEndPoint; //*
  final double
      phaseShift; //* shift the starting value of the wave, in radians, repeats every 2 radians
  final bool doClosePath;

  Path build() {
    double startPointX = startPoint.dx;
    double startPointY = startPoint.dy;
    Path returnPath = new Path();
    returnPath.moveTo(startPointX, startPointY);

    for (double i = 0; i <= width; i++) {
      returnPath.lineTo(
        i + startPointX,
        startPointY +
            amplitude *
                math.sin(
                    (i * 2 * period * math.pi / width) + phaseShift * math.pi),
      );
    }
    if (doClosePath == true) {
      returnPath.lineTo(startPointX + width, crossAxisEndPoint);
      returnPath.lineTo(startPointX, crossAxisEndPoint);
      returnPath.close();
    }
    return returnPath;
  }
}
