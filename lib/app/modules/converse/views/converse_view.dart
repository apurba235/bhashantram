import 'package:bhashantram/app/common/consts/asset_consts.dart';
import 'package:bhashantram/app/common/consts/color_consts.dart';
import 'package:bhashantram/app/common/widget/widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/converse_controller.dart';

class ConverseView extends GetView<ConverseController> {
  const ConverseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConsts.whiteColor,
        appBar: AppBar(
          title: const Text(
            'Converse',
            style: TextStyle(color: ColorConsts.blackColor, fontSize: 24),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: ColorConsts.whiteColor,
          elevation: 0.0,
          foregroundColor: ColorConsts.blackColor,
        ),
        body: Obx(() {
          return controller.languageLoader.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'English',
                                        style: TextStyle(color: ColorConsts.blueColor),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Hi, how are you ?',
                                        style: TextStyle(fontSize: 18, color: ColorConsts.blueColor),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(color: ColorConsts.blueColor),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          SizedBox(height: 15),
                                          Text(
                                            'Hindi',
                                            style: TextStyle(color: ColorConsts.tomatoRed),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'नमस्ते, क्या हालचाल ह ?',
                                            style: TextStyle(fontSize: 18, color: ColorConsts.tomatoRed),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 50),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(AssetConsts.share),
                                              const SizedBox(width: 15),
                                              Image.asset(AssetConsts.copy),
                                            ],
                                          ),
                                          const Spacer(),
                                          Image.asset(AssetConsts.speaker),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...List.generate(
                            2,
                            (index) => MicroPhone(
                              onTapMic: index == 0
                                  ? () {
                                      ///Source
                                    }
                                  : () {
                                      /// target
                                    },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...List.generate(
                            2,
                            (index) => LanguageButton(
                              languageName: index == 0
                                  ? (controller.getLanguageName(controller.sourceLang.value ?? 'Source'))
                                  : (controller.getLanguageName(controller.targetLang.value ?? 'Target')),
                              onTapButton: index == 0
                                  ? () {
                                      Get.bottomSheet(isDismissible: false, Obx(() {
                                        return
                                          AppBottomSheet(
                                          onTapSelect: () {
                                            Get.back();
                                          },
                                          selectButtonColor: (controller.sourceLang.value != null)
                                              ? ColorConsts.blueColor
                                              : ColorConsts.blueColor.withOpacity(0.3),
                                          customWidget: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                SizedBox(
                                                  height: Get.height * 0.4,
                                                  child: GridView.builder(
                                                    itemCount: (controller.languages.value?.languages?.length ?? 0),
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisExtent: 80),
                                                    itemBuilder: (cx, index) {
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller.sourceLang.value = controller.languages.value
                                                                      ?.languages?[index].sourceLanguage ??
                                                                  '';
                                                              controller.selectedSourceLangIndex = index;
                                                              controller.targetLang.value = null;
                                                              controller.selectedTargetLangIndex = -1;
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 12.0,
                                                                vertical: 20,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: index == controller.selectedSourceLangIndex
                                                                    ? Colors.grey.withOpacity(0.2)
                                                                    : null,
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Text(
                                                                controller.getLanguageName(
                                                                  controller.languages.value?.languages?[index]
                                                                          .sourceLanguage ??
                                                                      '',
                                                                ),
                                                                style: const TextStyle(color: ColorConsts.blueColor),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(color: ColorConsts.blueColor),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }));
                                    }
                                  : (index == 1 &&
                                          (controller.sourceLang.value != null &&
                                              (controller.sourceLang.value?.isNotEmpty ?? false)))
                                      ? () {
                                          Get.bottomSheet(isDismissible: false, Obx(() {
                                            return AppBottomSheet(
                                              onTapSelect: () {
                                                Get.back();
                                              },
                                              selectButtonColor: (controller.targetLang.value != null)
                                                  ? ColorConsts.blueColor
                                                  : ColorConsts.blueColor.withOpacity(0.3),
                                              customWidget: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    SizedBox(
                                                      height: Get.height * 0.4,
                                                      child: GridView.builder(
                                                        itemCount: (controller
                                                                .languages
                                                                .value
                                                                ?.languages?[controller.selectedSourceLangIndex]
                                                                .targetLanguageList
                                                                ?.length ??
                                                            0),
                                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing: 10.0,
                                                            mainAxisExtent: 80),
                                                        itemBuilder: (cx, index) {
                                                          return Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  controller.targetLang.value = controller
                                                                          .languages
                                                                          .value
                                                                          ?.languages?[
                                                                              controller.selectedSourceLangIndex]
                                                                          .targetLanguageList?[index] ??
                                                                      '';
                                                                  controller.selectedTargetLangIndex = index;
                                                                },
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 12.0,
                                                                    vertical: 20,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: index == controller.selectedTargetLangIndex
                                                                        ? Colors.grey.withOpacity(0.2)
                                                                        : null,
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: Text(
                                                                    controller.getLanguageName(
                                                                      controller
                                                                              .languages
                                                                              .value
                                                                              ?.languages?[
                                                                                  controller.selectedSourceLangIndex]
                                                                              .targetLanguageList?[index] ??
                                                                          '',
                                                                    ),
                                                                    style:
                                                                        const TextStyle(color: ColorConsts.blueColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              const Divider(color: ColorConsts.blueColor),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }));
                                        }
                                      : null,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                );
        }));
  }
}
