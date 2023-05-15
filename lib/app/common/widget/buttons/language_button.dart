import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.languageName,
    this.onTapButton,
  });

  final String languageName;
  final void Function()? onTapButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButton,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            children: [
              Text(
                languageName,
                style: const TextStyle(color: ColorConsts.blueColor),
              ),
              const SizedBox(width: 29),
              const Icon(Icons.arrow_drop_down_outlined, size: 30, color: ColorConsts.blueColor)
            ],
          ),
        ),
      ),
    );
  }
}
