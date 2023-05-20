import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender, this.audioPath}) : super(key: key);
  final String text;
  final String sender;
  final String? audioPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: sender == 'user' ? Alignment.topRight : Alignment.topLeft,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: sender == 'user'
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))
                        : const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                    color: sender == 'user' ? ColorConsts.blueColor : ColorConsts.lightgreyColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (audioPath?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap:(){},
                                    child: const Icon(Icons.play_circle_outlined, color: ColorConsts.whiteColor, size: 30)),
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
                          text,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: sender == 'user' ? ColorConsts.whiteColor : ColorConsts.blackColor,
                          ),
                        ),
                        sender == 'user'
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10, right: 10),
                                  width: 25,
                                  child: Image.asset(
                                    AssetConsts.speaker,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: sender == 'user'
                    ? const SizedBox()
                    : SizedBox(
                        width: 40,
                        child: Image.asset(
                          AssetConsts.bot,
                          fit: BoxFit.cover,
                        ),
                      ),
              )
            ],
          ),
        ),
        // Expanded(child: text.trim().text.bodyText1(context).make().px8())
      ],
    ).py8();
  }
}
