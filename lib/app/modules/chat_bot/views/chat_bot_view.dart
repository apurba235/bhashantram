import 'dart:developer';

import 'package:bhashantram/app/common/consts/asset_consts.dart';
import 'package:bhashantram/app/modules/chat_bot/views/response_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../common/consts/color_consts.dart';
import '../../../common/widget/bottomsheet/bottomsheet.dart';
import '../../../common/widget/buttons/language_button.dart';
import '../../../common/widget/component/microphone.dart';
import '../../../common/widget/snackbar/custom_snackbar.dart';
import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
  const ChatBotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConsts.whiteColor,
          elevation: 2,
          leadingWidth: 90,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BackButton(
                color: ColorConsts.blackColor,
                onPressed: () => Get.back(),
              ),
              Image.asset(
                AssetConsts.bot,
                width: 40,
                fit: BoxFit.cover,
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "ChatGPT",
                    style: TextStyle(fontSize: 16, color: ColorConsts.blackColor),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.circle, color: ColorConsts.greenColor, size: 12),
                      SizedBox(width: 5),
                      Text("Online", style: TextStyle(fontSize: 12, color: ColorConsts.greenColor)),
                    ],
                  ),
                ],
              ),
              Obx(() {
                return LanguageButton(
                    languageName: (controller.getLanguageName(controller.sourceLang.value ?? 'Language')),
                    onTapButton: () {
                      Get.bottomSheet(isDismissible: false, Obx(() {
                        return AppBottomSheet(
                          onTapSelect: () {
                            if (controller.sourceLang.value != 'en') {
                              controller.getTransliterationModelId();
                            } else {
                              controller.transliterationModelsId = "";
                            }
                            Get.back();
                          },
                          selectButtonColor: (controller.sourceLang.value != null)
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
                                      itemCount: (controller.languages.value?.languages?.length ?? 0),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisExtent: 80,
                                      ),
                                      itemBuilder: (cx, index) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.sourceLang.value =
                                                    controller.languages.value?.languages?[index].sourceLanguage ?? '';
                                                controller.getAsrAndTtsServiceId();
                                                if (controller.sourceLang.value != 'en') {
                                                  controller.getTranslationId();
                                                  controller.getResponseToOutputTranslationId();
                                                } else {
                                                  controller.translationId = "";
                                                  controller.responseToOutputTranslationId = "";
                                                }
                                                controller.selectedSourceLangIndex = index;
                                                controller.isLoading.value = true;
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
                                                child: Center(
                                                  child: Text(
                                                    controller.getLanguageName(
                                                      controller.languages.value?.languages?[index].sourceLanguage ??
                                                          '',
                                                    ),
                                                    style: const TextStyle(color: ColorConsts.blueColor),
                                                  ),
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
                    });
              }),
            ],
          ),
        ),
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: controller.conversations.value.length,
                      itemBuilder: (context, item) {
                        final data = controller.conversations.value[item];
                        return Stack(alignment: Alignment.topLeft, children: [
                          if (data.userType == 'bot')
                            Container(
                              width: 50,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle, color: ColorConsts.lightgreyColor),
                              child: Image.asset(
                                AssetConsts.bot,
                                fit: BoxFit.fill,
                              ),
                            ),
                          Align(
                            alignment: data.userType == 'user' ? Alignment.topRight : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(
                                  top: 25, bottom: 10, right: data.userType == "user" ? 0.0 : 40.0, left: 30.0),
                              decoration: BoxDecoration(
                                borderRadius: data.userType == 'user'
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                color: data.userType == 'user' ? ColorConsts.blueColor : ColorConsts.lightgreyColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data.audioPath?.isNotEmpty ?? false)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () async{
                                              if(data.isPlaying.value){
                                                ///pause
                                                data.isPlaying.value =false;
                                              }else{
                                                if (controller.previousPlayingIndex >= 0) {
                                                  controller.conversations.value[controller.previousPlayingIndex]
                                                      .isPlaying.value = false;
                                                }
                                                controller.previousPlayingIndex = item;
                                                data.isPlaying.value = true;
                                                await controller.playRecordedAudio(data.audioPath ?? '');
                                                data.isPlaying.value = false;
                                              }
                                            },
                                            child: Obx(
                                              () {
                                                return Icon(
                                                    data.isPlaying.value
                                                        ? Icons.pause_circle_outline_outlined
                                                        : Icons.play_circle_outlined,
                                                    color: ColorConsts.whiteColor,
                                                    size: 30);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: SvgPicture.asset(
                                              AssetConsts.wave,
                                              color: ColorConsts.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Text(
                                    data.message,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: data.userType == 'user' ? ColorConsts.whiteColor : ColorConsts.blackColor,
                                    ),
                                  ),
                                  if (data.userType == 'bot')
                                    GestureDetector(
                                      onTap: () {},
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                                          width: 25,
                                          child: Image.asset(
                                            AssetConsts.speaker,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ]);
                      },
                    ),
                  );
                }),
                // Obx(() {
                //   return Flexible(
                //     child: ListView.builder(
                //       itemCount: controller.chats.value.length,
                //       reverse: true,
                //       itemBuilder: (context, index) {
                //         return controller.chats.value[index];
                //       },
                //     ),
                //   );
                // }),
                if (controller.isLoad.value) const ThreeDots(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      height: 60,
                      child: _buildTextComposer(),
                    ),
                  ),
                ),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(controller.hints.value?.output?.first.target?.length ?? 0, (index) {
                          final data = controller.hints.value?.output?.first.target?[index] ?? '';
                          return GestureDetector(
                            onTap: () {
                              String temp = controller.chatController.text;
                              String output = temp.replaceAll(RegExp('[A-Za-z]'), '');
                              controller.chatController.text = '$output $data ';
                              controller.chatController.selection = TextSelection.fromPosition(
                                TextPosition(offset: controller.chatController.text.length),
                              );
                              controller.hints.value = null;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorConsts.greenColor.withOpacity(0.3)),
                                child: Text(data)),
                          );
                        })
                      ],
                    ),
                  );
                })
              ],
            ),
          );
        }));
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Expanded(child: Obx(() {
            return TextField(
              onTap: () {
                if (controller.sourceLang.value?.isNotEmpty ?? false) {
                  return;
                } else {
                  showSnackBar('Please select source language first.');
                }
              },
              readOnly: controller.isLoading.value ? false : true,
              autofocus: false,
              controller: controller.chatController,
              decoration: const InputDecoration.collapsed(
                hintText: "Hello ChatGPT!",
                hintStyle: TextStyle(fontSize: 16, color: ColorConsts.blueColor),
              ),
              onChanged: (v) {
                controller.getTransliterationInput();
                if (!(v[v.length - 1].contains(RegExp('[^A-Za-z]'))) &&
                    (controller.sourceLang.isNotEmpty ?? false) &&
                    (controller.sourceLang.value != 'en')) {
                  controller.computeTransliteration();
                }
              },
            );
          })),
          Obx(() {
            return MicroPhone(
              onTapMic: (ongoing) {
                log('started ');
                controller.startRecording();
              },
              onTapCancel: () async {
                log('stopped');
                await controller.stopRecordingAndGetResult();
                await controller.computeAsr();
                await controller.sendMessage();
              },
              padding: const EdgeInsets.all(10),
              micHeight: 20,
              micColor: controller.recordingOngoing.value ? Colors.red : null,
            );
          }),
          IconButton(
              onPressed: () {
                controller.sendMessage();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              icon: Image.asset(AssetConsts.send)),
        ],
      ),
    );
  }
}
