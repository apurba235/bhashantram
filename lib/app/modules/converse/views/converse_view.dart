import 'package:bhashantram/app/common/consts/asset_consts.dart';
import 'package:bhashantram/app/common/consts/color_consts.dart';
import 'package:bhashantram/app/common/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
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
      body: Obx(
        () {
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
                              Obx(() {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.getLanguageName(controller.sourceLang.value ?? 'Source'),
                                          style: const TextStyle(color: ColorConsts.blueColor),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          controller.input.value ?? 'Press mic to begin conversion',
                                          style: const TextStyle(fontSize: 18, color: ColorConsts.blueColor),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              const Divider(color: ColorConsts.blueColor),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Text(
                                              controller.getLanguageName(controller.targetLang.value ?? 'Target'),
                                              style: const TextStyle(color: ColorConsts.tomatoRed),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              controller.output.value ?? 'Press mic to begin conversion',
                                              style: const TextStyle(fontSize: 18, color: ColorConsts.tomatoRed),
                                            ),
                                          ],
                                        );
                                      }),
                                      const SizedBox(height: 50),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (controller.ttsFilePath.isNotEmpty) {
                                                    await Share.shareXFiles(
                                                      [XFile(controller.ttsFilePath)],
                                                      sharePositionOrigin:
                                                          Rect.fromLTWH(0, 0, Get.width, Get.height / 2),
                                                    );
                                                  }
                                                },
                                                child: Image.asset(AssetConsts.share),
                                              ),
                                              const SizedBox(width: 15),
                                              GestureDetector(
                                                onTap: (controller.output.value?.isNotEmpty ?? false)
                                                    ? () async {
                                                        await Clipboard.setData(
                                                          ClipboardData(text: controller.output.value ?? ''),
                                                        );
                                                        showSnackBar('Copied to clipboard');
                                                      }
                                                    : null,
                                                child: Image.asset(AssetConsts.copy),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Obx(() {
                                            return GestureDetector(
                                              onTap: () {
                                                if (controller.ttsFilePath.isNotEmpty) {
                                                  controller.playRecordedAudio(controller.ttsFilePath);
                                                }
                                              },
                                              child: controller.playingAudio.value
                                                  ? const Icon(Icons.pause_circle_outline_outlined)
                                                  : Image.asset(AssetConsts.speaker),
                                            );
                                          }),
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
                      Obx(() {
                        return Stack(
                          children: [
                            if (controller.recordingOngoing.value) Lottie.asset(AssetConsts.recording, repeat: true),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ...List.generate(
                                  2,
                                  (index) => MicroPhone(
                                    onTapMic: (ongoing) {
                                      if ((controller.sourceLang.isNotEmpty ?? false) &&
                                          (controller.targetLang.isNotEmpty ?? false)) {
                                        controller.startRecording();
                                      } else {
                                        showSnackBar('Please select both language.');
                                      }
                                    },
                                    onTapRemove: ((controller.sourceLang.isNotEmpty ?? false) &&
                                            (controller.targetLang.isNotEmpty ?? false))
                                        ? (te) async {
                                            controller.fromTarget = index == 0 ? false : true;
                                            await controller.stopRecordingAndGetResult();
                                            await controller.workingData();
                                            controller.computeAsrTranslationTts();
                                          }
                                        : null,
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
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
                                          customWidget: SingleChildScrollView(
                                            child: Padding(
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
                                                child: SingleChildScrollView(
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
                                              ),
                                            );
                                          }));
                                        }
                                      : () => showSnackBar('Please select source language first.'),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                );
        },
      ),
    );
  }
}
