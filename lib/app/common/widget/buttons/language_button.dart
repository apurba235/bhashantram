import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.languageName,
    this.onTapButton,
    this.color = ColorConsts.blueColor,
  });

  final String languageName;
  final void Function()? onTapButton;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButton,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                languageName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 22),
              ),
            ),
            const SizedBox(width: 29),
            Icon(Icons.arrow_drop_down_outlined, size: 30, color: color)
          ],
        ),
      ),
    );
  }
}
