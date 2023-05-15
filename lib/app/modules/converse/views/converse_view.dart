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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: MediaQuery.of(context).padding.top),
              // const SizedBox(height: 30),
              // const Text(
              //   'Converse',
              //   style: TextStyle(fontSize: 24),
              // ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'English',
                            style: TextStyle(fontSize: 12, color: ColorConsts.blueColor),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Hi, how are you ?',
                            style: TextStyle(fontSize: 16, color: ColorConsts.blueColor),
                          ),
                          SizedBox(height: 15),
                          Divider(color: ColorConsts.blueColor),
                          SizedBox(height: 15),
                          Text(
                            'Hindi',
                            style: TextStyle(fontSize: 12, color: ColorConsts.tomatoRed),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'नमस्ते, क्या हालचाल ह ?',
                            style: TextStyle(fontSize: 16, color: ColorConsts.tomatoRed),
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
                      )
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
                      languageName: index == 0 ? 'Source' : 'Target',
                      onTapButton: index == 0 ? () {} : (){},
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
