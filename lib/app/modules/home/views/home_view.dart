import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../common/widget/widget.dart';
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
      body: SingleChildScrollView(
        child: Column(
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
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 20.0),
                    child: Text(
                      StringConsts.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50, color: ColorConsts.whiteColor),
                    ),
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
      ),
    );
  }
}