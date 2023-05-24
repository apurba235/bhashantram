import 'dart:ui';

import 'package:bhashantram/app/common/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    Key? key,
    required this.lottieAsset,
    required this.footerText,
  }) : super(key: key);

  final String lottieAsset;
  final String footerText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.56)),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: ColorConsts.whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  lottieAsset,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 14),
                Text(footerText, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
