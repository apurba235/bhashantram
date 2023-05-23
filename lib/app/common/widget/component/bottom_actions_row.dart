import 'package:flutter/material.dart';

class BottomActionsRow extends StatelessWidget {
  const BottomActionsRow({
    super.key, this.onTapShare, this.onTapCopy, required this.playerWidget,
  });

  final void Function()? onTapShare;
  final void Function()? onTapCopy;
  final Widget playerWidget;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onTapShare,
              child: const Icon(Icons.share),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: onTapCopy,
              child: const Icon(Icons.copy),
            ),
          ],
        ),
        const Spacer(),
        playerWidget,
      ],
    );
  }
}
