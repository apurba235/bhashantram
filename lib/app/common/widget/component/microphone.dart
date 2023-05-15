import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class MicroPhone extends StatelessWidget {
  const MicroPhone({
    super.key,
    this.onTapMic,
  });

  final void Function()? onTapMic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMic,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConsts.blueColor.withOpacity(0.3),
        ),
        child: Image.asset(AssetConsts.microphone),
      ),
    );
  }
}
