import 'package:flutter/material.dart';

import '../../consts/consts.dart';

class BotAppBarTitle extends StatelessWidget {
  const BotAppBarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          StringConsts.botName,
          style: TextStyle(fontSize: 16, color: ColorConsts.blackColor),
        ),
        Row(
          children: const [
            Icon(Icons.circle, color: ColorConsts.greenColor, size: 12),
            SizedBox(width: 5),
            Text(StringConsts.online, style: TextStyle(fontSize: 12, color: ColorConsts.greenColor)),
          ],
        ),
      ],
    );
  }
}
