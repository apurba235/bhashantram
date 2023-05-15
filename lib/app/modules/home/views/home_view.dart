import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.blueAccent
        )
    );
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: Get.height * 0.41,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetConsts.homeBackground),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0, top: 20.0),
                child: Text(
                  StringConsts.appName,
                  style: TextStyle(fontSize: 24, color: ColorConsts.whiteColor),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  controller.menuItems.length,
                  (index) => MenuItem(
                    cardBackgroundImage: controller.menuItems[index].menuBackgroundImage,
                    menuIcon: controller.menuItems[index].menuIcon,
                    menuTitle: controller.menuItems[index].menuTitle,
                    menuSubTitle: controller.menuItems[index].menuSubTitle,
                    onTapMenu: controller.menuItems[index].onTapMenu,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
  final String menuIcon;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(menuIcon),
            const SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuTitle,
                  style: const TextStyle(color: ColorConsts.whiteColor, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  menuSubTitle,
                  style: const TextStyle(color: ColorConsts.whiteColor, fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
