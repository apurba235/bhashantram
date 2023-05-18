import 'package:bhashantram/app/common/consts/asset_consts.dart';
import 'package:bhashantram/app/modules/chat_bot/views/response_animation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/consts/color_consts.dart';
import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
  ChatBotView({Key? key}) : super(key: key);

  List<String> myList = ["English", "Tamil", "Kanada", "Gujrati", "Hindi"];

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
                  Text(
                    "ChatGPT",
                    style:
                        TextStyle(fontSize: 16, color: ColorConsts.blackColor),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: ColorConsts.greenColor,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Online",
                          style: TextStyle(
                              fontSize: 12, color: ColorConsts.greenColor)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: buildBottomSheet,
                      shape: const RoundedRectangleBorder(
                        // <-- SEE HERE
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorConsts.blackColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Language",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff00E173),
                        )
                      ],
                    ),
                  ),
                ),
              ),
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
              ),
            ],
          ),
        ));
  }

  Widget buildBottomSheet(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
            child: Text(
          "Select Language",
          style: TextStyle(fontSize: 16, color: ColorConsts.blueColor),
        )),
        Container(
          height: MediaQuery.of(context).size.height / 2.2,
          child: ListView.builder(
            padding: EdgeInsets.all(40),
            itemBuilder: (
              context,
              index,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(myList[index],
                      style: TextStyle(
                          fontSize: 12, color: ColorConsts.blueColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(color: ColorConsts.blueColor)
                ],
              );
            },
            itemCount: myList.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade100,
            ),
            height: 40,
            child: Center(
                child: Text("Select",
                    style: TextStyle(
                        fontSize: 20, color: ColorConsts.whiteColor))),
          ),
        ),
      ],
    );
  }

  Widget _buidTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: false,
              controller: controller.chatController,
              decoration: InputDecoration.collapsed(
                  hintText: "Hello ChatGPT!",
                  hintStyle:
                      TextStyle(fontSize: 16, color: ColorConsts.blueColor)),
            ),
          ),
          IconButton(
              onPressed: () {
               // controller. sendMessage();
              },
              icon: Icon(Icons.mic, color: ColorConsts.greyColor)),
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
