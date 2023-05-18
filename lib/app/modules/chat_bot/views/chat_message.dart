import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key ? key,
    required this.text,
    required this.sender
  }): super(key: key);
  // Use for User Input and chatbot output
  final String text;
  // Use for check sender is user or bot
  final String sender;
  @override
  Widget build(BuildContext context) {
    return
    Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: sender=='user'?Alignment.topRight:Alignment.topLeft,
        child:
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 30,top: 30),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:sender=='user'? BorderRadius.only(topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)):BorderRadius.only(topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: sender=='user'?ColorConsts.blueColor:ColorConsts.lightgreyColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                         // sender=='user'?
                          Column(
                            children: [
                              Text(text,style: TextStyle(fontSize: 12,fontFamily: 'Poppins',
                              color: sender=='user'?ColorConsts.whiteColor:ColorConsts.blackColor)),
                              sender=='user'?SizedBox():Align(
                                alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10,right: 10),
                                      width: 25,
                                      child: Image.asset(AssetConsts.speaker,fit: BoxFit.cover,))),
                            ],
                          )
                        //       :
                        //
                        // AnimatedTextKit(
                        //   isRepeatingAnimation: false,
                        //   totalRepeatCount: 0,
                        //   repeatForever: false,
                        //   animatedTexts: [
                        //   TypewriterAnimatedText(text,textStyle: TextStyle(fontSize: 12,fontFamily: 'Poppins',
                        //       color: sender=='user'?ColorConsts.whiteColor:ColorConsts.blackColor)),
                        // ],),
                    )),
              ),
              Positioned(
                  child:
                  sender=='user'?SizedBox():
                  Container(width: 40,
                      child: Image.asset(AssetConsts.bot,fit: BoxFit.cover,))
              )

            ],),
      ),
      // Expanded(child: text.trim().text.bodyText1(context).make().px8())
    ], ).py8();
  }
}