import 'package:flutter/cupertino.dart';

class MenuModel {
  String menuBackgroundImage;
  Icon menuIcon;
  String menuTitle;
  String menuSubTitle;
  void Function()? onTapMenu;

  MenuModel({
    required this.menuBackgroundImage,
    required this.menuIcon,
    required this.menuTitle,
    required this.menuSubTitle,
    this.onTapMenu,
  });
}
