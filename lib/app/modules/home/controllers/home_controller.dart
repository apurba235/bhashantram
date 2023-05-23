
import 'package:get/get.dart';

import '../../../common/consts/consts.dart';
import '../../../data/ui_models/menu_model.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  List<MenuModel> menuItems = [
    MenuModel(
        menuBackgroundImage: AssetConsts.flagOne,
        menuIcon: AssetConsts.translate,
        menuTitle: StringConsts.converse,
        menuSubTitle: StringConsts.converseSubTitle,
        onTapMenu: () => Get.toNamed(Routes.CONVERSE)),
    MenuModel(
      menuBackgroundImage: AssetConsts.flagTwo,
      menuIcon: AssetConsts.camera,
      menuTitle: StringConsts.botName,
      menuSubTitle: StringConsts.poweredByChatGpt,
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
