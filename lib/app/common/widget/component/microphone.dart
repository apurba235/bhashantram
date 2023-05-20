import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class MicroPhone extends StatelessWidget {
  const MicroPhone({
    super.key,
    required this.onTapMic,
    this.onTapRemove,
    this.padding,
    this.micHeight,
  });

  final void Function(TapDownDetails)? onTapMic;
  final void Function(TapUpDetails)? onTapRemove;
  final EdgeInsets? padding;
  final double? micHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapMic,
      onTapUp: onTapRemove,
      // onTap: onTapMic,
      child: Container(
        padding: padding ?? const EdgeInsets.all(25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConsts.blueColor.withOpacity(0.3),
        ),
        child: Image.asset(AssetConsts.microphone, height: micHeight),
      ),
    );
  }
}
