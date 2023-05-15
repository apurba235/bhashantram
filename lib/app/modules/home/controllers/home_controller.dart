import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:bhashantram/app/data/ui_models/menu_model.dart';
import 'package:bhashantram/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<MenuModel> menuItems = [
    MenuModel(
        menuBackgroundImage: AssetConsts.flagOne,
        menuIcon: AssetConsts.translate,
        menuTitle: 'Converse',
        menuSubTitle: 'Start converstation to your preferred language',
        onTapMenu: () => Get.toNamed(Routes.CONVERSE)),
    MenuModel(
      menuBackgroundImage: AssetConsts.flagTwo,
      menuIcon: AssetConsts.camera,
      menuTitle: 'Chat Bot',
      menuSubTitle: 'Ask question to the bot',
      onTapMenu: () => Get.toNamed(Routes.CHAT_BOT),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
