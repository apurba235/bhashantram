import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../../../common/consts/consts.dart';
import '../../../common/widget/widget.dart';
import '../controllers/converse_controller.dart';

class ConverseView extends GetView<ConverseController> {
  const ConverseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.whiteColor,
      appBar: AppBar(
        title: const Text(
          StringConsts.converse,
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
              : Obx(() {
                  return Stack(
                    children: [
                      Padding(
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
                                          padding: const EdgeInsets.all(30.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.getLanguageName(
                                                        controller.sourceLang.value ?? StringConsts.sourceLanguage),
                                                    style: const TextStyle(color: ColorConsts.blueColor, fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    controller.input.value ?? StringConsts.initialConverseLabel,
                                                    style: const TextStyle(fontSize: 20, color: ColorConsts.blueColor),
                                                  ),
                                                  const SizedBox(height: 15),
                                                ],
                                              ),
                                              BottomActionsRow(
                                                onTapShare: () async {
                                                  if (controller.inputAudioPath.isNotEmpty) {
                                                    await Share.shareXFiles(
                                                      [XFile(controller.inputAudioPath)],
                                                      sharePositionOrigin:
                                                      Rect.fromLTWH(0, 0, Get.width, Get.height / 2),
                                                    );
                                                  } else {
                                                    showSnackBar(StringConsts.shareError);
                                                  }
                                                },
                                                onTapCopy: (controller.input.value?.isNotEmpty ?? false)
                                                    ? () async {
                                                  await Clipboard.setData(
                                                    ClipboardData(text: controller.input.value ?? ''),
                                                  );
                                                  showSnackBar(StringConsts.copiedSuccessfully);
                                                }
                                                    : () => showSnackBar(StringConsts.copiedError),
                                                playerWidget: Obx(() {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (controller.inputAudioPath.isNotEmpty) {
                                                        controller.playRecordedAudio(controller.inputAudioPath, true);
                                                      } else {
                                                        showSnackBar(StringConsts.playError);
                                                      }
                                                    },
                                                    child: controller.inputAudioPlay.value
                                                        ? const Icon(Icons.pause_circle_outline_outlined, size: 30)
                                                        : const Icon(Icons.play_circle_outlined, size: 30),
                                                  );
                                                }),
                                              ),
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
                                                    controller.getLanguageName(
                                                        controller.targetLang.value ?? StringConsts.targetLanguage),
                                                    style: const TextStyle(color: ColorConsts.tomatoRed, fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    controller.output.value ?? StringConsts.initialConverseLabel,
                                                    style: const TextStyle(fontSize: 20, color: ColorConsts.tomatoRed),
                                                  ),
                                                ],
                                              );
                                            }),
                                            BottomActionsRow(
                                              onTapShare: () async {
                                                if (controller.outputAudioPath.isNotEmpty) {
                                                  await Share.shareXFiles(
                                                    [XFile(controller.outputAudioPath)],
                                                    sharePositionOrigin:
                                                    Rect.fromLTWH(0, 0, Get.width, Get.height / 2),
                                                  );
                                                } else {
                                                  showSnackBar(StringConsts.shareError);
                                                }
                                              },
                                              onTapCopy: (controller.output.value?.isNotEmpty ?? false)
                                                  ? () async {
                                                await Clipboard.setData(
                                                  ClipboardData(text: controller.output.value ?? ''),
                                                );
                                                showSnackBar(StringConsts.copiedSuccessfully);
                                              }
                                                  : () => showSnackBar(StringConsts.copiedError),
                                              playerWidget: Obx(() {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (controller.outputAudioPath.isNotEmpty) {
                                                    controller.playRecordedAudio(controller.outputAudioPath, false);
                                                  } else {
                                                    showSnackBar(StringConsts.playError);
                                                  }
                                                },
                                                child: controller.outputAudioPlay.value
                                                    ? const Icon(Icons.pause_circle_outline_outlined, size: 30)
                                                    : const Icon(Icons.play_circle_outlined, size: 30),
                                              );
                                            }),),
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
                                alignment: Alignment.center,
                                children: [
                                  if (controller.recordingOngoing.value)
                                    SizedBox(height: 70, child: Lottie.asset(AssetConsts.recording, repeat: true)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ...List.generate(
                                        2,
                                        (index) => MicroPhone(
                                          onTapMic: (ongoing) {
                                            if ((controller.sourceLang.isNotEmpty ?? false) &&
                                                (controller.targetLang.isNotEmpty ?? false)) {
                                              HapticFeedback.vibrate();
                                              controller.startRecording();
                                            } else {
                                              showSnackBar(StringConsts.languageSelectionError);
                                            }
                                          },
                                          onTapCancel: ((controller.sourceLang.isNotEmpty ?? false) &&
                                                  (controller.targetLang.isNotEmpty ?? false))
                                              ? () async {
                                                  controller.fromTarget = index == 0 ? false : true;
                                                  await controller.stopRecordingAndGetResult();
                                                  await controller.workingData();
                                                  controller.computeAsrTranslationTts();
                                                }
                                              : null,
                                          micHeight: 35,
                                          micColor: index == 1 ? ColorConsts.tomatoRed : null,
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
                                  (index) => Flexible(
                                    child: LanguageButton(
                                      color: index == 1 ? ColorConsts.tomatoRed : ColorConsts.blueColor,
                                      languageName: index == 0
                                          ? (controller.getLanguageName(
                                              controller.sourceLang.value ?? StringConsts.sourceLanguage))
                                          : (controller.getLanguageName(
                                              controller.targetLang.value ?? StringConsts.targetLanguage)),
                                      onTapButton: index == 0
                                          ? () {
                                              Get.bottomSheet(isDismissible: false, Obx(() {
                                                return AppBottomSheet(
                                                  selectButtonColor: (controller.sourceLang.value != null)
                                                      ? ColorConsts.blueColor
                                                      : ColorConsts.blueColor.withOpacity(0.3),
                                                  customWidget: SingleChildScrollView(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          SizedBox(
                                                            height: Get.height * 0.5,
                                                            child: Scrollbar(
                                                              controller: controller.languageScrollController,
                                                              thumbVisibility: true,
                                                              child: GridView.builder(
                                                                controller: controller.languageScrollController,
                                                                itemCount:
                                                                    (controller.languages.value?.languages?.length ??
                                                                        0),
                                                                gridDelegate:
                                                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                                          controller.sourceLang.value = controller
                                                                                  .languages
                                                                                  .value
                                                                                  ?.languages?[index]
                                                                                  .sourceLanguage ??
                                                                              '';
                                                                          controller.selectedSourceLangIndex = index;
                                                                          controller.targetLang.value = null;
                                                                          controller.selectedTargetLangIndex = -1;
                                                                          Get.back();
                                                                        },
                                                                        child: Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 12.0,
                                                                            vertical: 20,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color: index ==
                                                                                    controller.selectedSourceLangIndex
                                                                                ? Colors.grey.withOpacity(0.2)
                                                                                : null,
                                                                            borderRadius: BorderRadius.circular(12),
                                                                          ),
                                                                          child: Text(
                                                                            controller.getLanguageName(
                                                                              controller
                                                                                      .languages
                                                                                      .value
                                                                                      ?.languages?[index]
                                                                                      .sourceLanguage ??
                                                                                  '',
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                            style: const TextStyle(
                                                                                color: ColorConsts.blueColor,
                                                                                fontSize: 16),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(color: ColorConsts.blueColor),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
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
                                                      selectButtonColor: (controller.targetLang.value != null)
                                                          ? ColorConsts.blueColor
                                                          : ColorConsts.blueColor.withOpacity(0.3),
                                                      customWidget: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            children: [
                                                              SizedBox(
                                                                height: Get.height * 0.5,
                                                                child: Scrollbar(
                                                                  controller: controller.languageScrollController,
                                                                  thumbVisibility: true,
                                                                  child: GridView.builder(
                                                                    controller: controller.languageScrollController,
                                                                    itemCount: (controller
                                                                            .languages
                                                                            .value
                                                                            ?.languages?[
                                                                                controller.selectedSourceLangIndex]
                                                                            .targetLanguageList
                                                                            ?.length ??
                                                                        0),
                                                                    gridDelegate:
                                                                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                                                      ?.languages?[controller
                                                                                          .selectedSourceLangIndex]
                                                                                      .targetLanguageList?[index] ??
                                                                                  '';
                                                                              controller.selectedTargetLangIndex =
                                                                                  index;
                                                                              Get.back();
                                                                            },
                                                                            child: Container(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 12.0,
                                                                                vertical: 20,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: index ==
                                                                                        controller
                                                                                            .selectedTargetLangIndex
                                                                                    ? Colors.grey.withOpacity(0.2)
                                                                                    : null,
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              child: Text(
                                                                                controller.getLanguageName(
                                                                                  controller
                                                                                          .languages
                                                                                          .value
                                                                                          ?.languages?[controller
                                                                                              .selectedSourceLangIndex]
                                                                                          .targetLanguageList?[index] ??
                                                                                      '',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(
                                                                                    color: ColorConsts.blueColor,
                                                                                    fontSize: 18),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Divider(color: ColorConsts.blueColor),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                                }
                                              : () => showSnackBar(StringConsts.sourceLanguageSelectionError),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 30)
                          ],
                        ),
                      ),
                      controller.computationLoader.value
                          ? const LoadingAnimation(
                              lottieAsset: AssetConsts.loading,
                              footerText: StringConsts.loadingText,
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                });
        },
      ),
    );
  }
}