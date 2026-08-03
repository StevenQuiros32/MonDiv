import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Replica las decoraciones ".wave-top" y ".wave-bottom" del HTML original.
/// [showWaves] controla su visibilidad (equivalente a la clase "no-wave").
class WaveBackground extends StatelessWidget {
  final bool showWaves;
  final Widget child;

  const WaveBackground({
    super.key,
    required this.child,
    this.showWaves = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showWaves) ...[
          Positioned(
            top: 0,
            left: 0,
            child: _WaveShape(
              alignTopLeft: true,
              widthFactor: 0.46,
              height: 130,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _WaveShape(
              alignTopLeft: false,
              widthFactor: 0.46,
              height: 150,
            ),
          ),
        ],
        child,
      ],
    );
  }
}

class _WaveShape extends StatelessWidget {
  final bool alignTopLeft;
  final double widthFactor;
  final double height;

  const _WaveShape({
    required this.alignTopLeft,
    required this.widthFactor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * widthFactor;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: alignTopLeft
            ? BorderRadius.only(
                bottomRight: Radius.elliptical(width, height * 0.9),
              )
            : BorderRadius.only(
                topLeft: Radius.elliptical(width, height * 0.9),
              ),
      ),
    );
  }
}
