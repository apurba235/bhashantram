import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../views/chat_message.dart';
import 'package:http/http.dart' as http;


class ChatBotController extends GetxController {
   TextEditingController chatController = TextEditingController();
   String apiKey = "32c8f6789c1649f588d42312a2d827d0";
   Rx<List<ChatMessage>> chats = Rx<List<ChatMessage>>([]);
   Future < void > sendMessage() async {
    ChatMessage message = ChatMessage(text: chatController.text, sender: "user");
    // setState(() {
    //   _message.insert(0, message);
    // });
   // chats.add(message);
    chats.value.insert(0, message);
    log(chats.value.first.text,name:"check");
    chatController.clear();
    final response = await sendMessageToGpt(message.text);
    ChatMessage botMessage = ChatMessage(text: response, sender: "bot");
    // Refresh the page
    // setState(() {
    //   _message.insert(0, botMessage);
    // });
   // chats.add(botMessage);

    chats.value.insert(0, botMessage);

   }
  final List<Map<String,String>>mymessage=[];
  Future sendMessageToGpt(String message)async{
    var url = Uri.parse('https://bigaidea.openai.azure.com/openai/deployments/bigaidea/chat/completions?api-version=2023-03-15-preview');

    mymessage.add({
      "role":"system",
      "content":message,
    });
    Map < String, dynamic > body = {
      "model": "gpt-3.5-turbo",
      "messages": mymessage,
      "max_tokens": 200,
    };
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "api-key": "$apiKey"
        },
        body: json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      Map<String,dynamic>  parseResponse=json.decode(response.body);

      String content=  parseResponse["choices"][0]["message"]["content"];
      content=content.trim();
      print(content);

      mymessage.add({
        "role":"user",
        "content":content
      });
      return content;
    } else {
      return "Failed to generate text: ${response.body}";
    }

  }




  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
