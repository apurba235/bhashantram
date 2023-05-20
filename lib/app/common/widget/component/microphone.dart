import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class MicroPhone extends StatelessWidget {
  const MicroPhone({
    super.key,
    required this.onTapMic,
    this.padding,
    this.micHeight,
    this.micColor, this.onTapCancel,
  });

  final void Function(TapDownDetails)? onTapMic;
  final void Function()? onTapCancel;
  final EdgeInsets? padding;
  final double? micHeight;
  final Color? micColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapMic,
      onTapUp: (te){
        onTapCancel!();
      },
      onPanEnd: (te){
        onTapCancel!();
      },
      onTapCancel: onTapCancel,
      child: Container(
        padding: padding ?? const EdgeInsets.all(25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: micColor?.withOpacity(0.3) ?? ColorConsts.blueColor.withOpacity(0.3),
        ),
        child: Icon(
          Icons.mic_rounded,
          size: micHeight,
          color: micColor ?? ColorConsts.blueColor,
        ),
      ),
    );
  }
}
