import 'package:flutter/material.dart';

import '../../consts/consts.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    this.onTapMenu,
    required this.cardBackgroundImage,
    required this.menuIcon,
    required this.menuTitle,
    required this.menuSubTitle,
  });

  final void Function()? onTapMenu;
  final String cardBackgroundImage;
  final Icon menuIcon;
  final String menuTitle;
  final String menuSubTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMenu,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(cardBackgroundImage),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(ColorConsts.blackColor.withOpacity(0.8), BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            menuIcon,
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuTitle,
                    style: const TextStyle(color: ColorConsts.whiteColor, fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    menuSubTitle,
                    style: const TextStyle(color: ColorConsts.whiteColor, fontSize: 15),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
