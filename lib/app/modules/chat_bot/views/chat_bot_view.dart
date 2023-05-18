import 'package:bhashantram/app/common/consts/asset_consts.dart';
import 'package:bhashantram/app/modules/chat_bot/views/response_animation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/consts/color_consts.dart';
import '../../../common/widget/bottomsheet/bottomsheet.dart';
import '../../../common/widget/buttons/language_button.dart';
import '../../../common/widget/snackbar/custom_snackbar.dart';
import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
  ChatBotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConsts.whiteColor,
          elevation: 2,
          leadingWidth: 50,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
                width: 40,
                child: Image.asset(
                  AssetConsts.bot,
                  width: 40,
                  fit: BoxFit.cover,
                )),
          ),
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ChatGPT",
                    style:
                        TextStyle(fontSize: 16, color: ColorConsts.blackColor),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: ColorConsts.greenColor,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Online",
                          style: TextStyle(
                              fontSize: 12, color: ColorConsts.greenColor)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Obx((){
                return
                  Row(
                  children: [
                    ...List.generate(
                      1,
                          (index) => LanguageButton(
                            languageName: index == 0
                            ? (controller.getLanguageName(controller.sourceLang.value ?? 'Language'))
                            : "",
                        onTapButton: index == 0
                            ? () {
                          Get.bottomSheet(isDismissible: false, Obx(() {
                            return
                              AppBottomSheet(
                                onTapSelect: () {
                                  controller.getTransliterationModelId();
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
                                                      child:
                                                      Center(
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
                ) ;
              }),
            ],
          ),
        ),
        body:
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              Obx(() {
                return
                  Flexible(
                  child:
                  ListView.builder(
                    itemCount: controller.chats.value.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return controller.chats.value[index];
                    },
                  ),
                );
              }),
        if(controller.isLoad.value)ThreeDots(),

            Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Container(
                    height: 60,
                    child: _buidTextComposer(),
                  ),
                ),
              )

            ],
          ),
        ));
  }


  Widget _buidTextComposer() {

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child:
      Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: false,
              controller: controller.chatController,
              decoration: const InputDecoration.collapsed(
                  hintText: "Hello ChatGPT!",
                  hintStyle:
                      const TextStyle(fontSize: 16, color: ColorConsts.blueColor)),
              onChanged: (v){
                controller.getTransliterationInput();
                if (!(v[v.length - 1]
                    .contains(RegExp('[^A-Za-z]'))) &&
                    (controller.sourceLang.isNotEmpty ??
                        false)) {
                  controller.computeTransliteration();
                }
                },
            ),
          ),
          IconButton(
              onPressed: () {
               // controller. sendMessage();
              },
              icon: const Icon(Icons.mic, color: ColorConsts.greyColor)),
          IconButton(
              onPressed: () {
                controller. sendMessage();
                FocusManager.instance.primaryFocus?.unfocus();


              },
              icon: Image.asset(AssetConsts.send)),
        ],
      ),
    );
  }
}
