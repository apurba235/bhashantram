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
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:sender=='user'? BorderRadius.only(topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)):BorderRadius.only(topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    color: sender=='user'?Colors.blue:Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text,style: TextStyle(fontSize: 12),),
                )),
          ),
          // Expanded(child: text.trim().text.bodyText1(context).make().px8())
        ], ).py8();
  }
}