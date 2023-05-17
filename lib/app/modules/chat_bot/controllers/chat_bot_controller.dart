import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../common/consts/app_url.dart';
import '../views/chat_message.dart';
import 'package:http/http.dart' as http;


class ChatBotController extends GetxController {
   TextEditingController chatController = TextEditingController();
   String apiKey = AppUrl.chatApikey;
   late String content;
   late String contentlength;
   late String check="-->";

   Rx<List<ChatMessage>> chats = Rx<List<ChatMessage>>([]);
    RxBool isLoad=RxBool(false);

   Future < void > sendMessage() async {
     isLoad.value=true;
    ChatMessage message = ChatMessage(text: chatController.text, sender: "user");

     chats.value.insert(0, message);
     chats.refresh();

    log(chats.value.first.text,name:"check");
    chatController.clear();
    final response = await sendMessageToGpt(message.text);
    ChatMessage botMessage = ChatMessage(text: response, sender: "bot");
    chats.value.insert(0, botMessage);
     isLoad.value=false;
     chats.refresh();

   }
  final List<Map<String,String>>mymessage=[];
  final List<Map<String,String>>fulldata=[];
  Future sendMessageToGpt(String message)async{
    var url = Uri.parse(AppUrl.chatUrl);
    if(message.contains(check)){
      mymessage.clear();
      mymessage.add({
        "role":"system",
         "content":"You are an Indian Citizen working with Government going to act like a very helpful assistant with all the knowledge that there is to offer about India."
             " You know everything there is to know about $message. You will be asked certain questions and you will respond very factually taking into context that the person asking the the questions is an Indian Citizen too."
             " Try to provide your answers concisely within word limit of not more than 30 words and using a single sentence.",
      });

      mymessage.add({
        "role":"user",
        "content":message,
      });

    }
    else{
      mymessage.add({
        "role":"user",
        "content":"$message.Please provide your answer within the word limit of 100 words",
      });
    }
    log('mymessage$mymessage');

    Map < String, dynamic > body = {
      "model": "gpt-3.5-turbo",
      "messages": mymessage,
      "max_tokens": 60,
      "temperature":0.6,
    };
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "api-key": "$apiKey"
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      Map<String,dynamic>  parseResponse=json.decode(response.body);
      print("show>>$parseResponse");

       content=  parseResponse["choices"][0]["message"]["content"];
       contentlength=parseResponse["choices"][0]["finish_reason"];

       print("content>>$content");
       print("contentLength>>$contentlength");
      content=content.trim();
       if(mymessage.length==1){
      content+="\n\n Please set the Topic in following manner :\n --> Topic_name";

    }
       // fulldata.add({
       //   "role":"user",
       //   "content":"Please compelete the previous answer."
       // });
      mymessage.add({
        "role":"assistant",
        "content":content,
      });
       // if(contentlength=="length"){
       //   fulldata.add({
       //     "role":"assistant",
       //     "content":content,
       //   });
       //   fulldata.add({
       //     "role":"user",
       //     "content":"$content Please compelete the previous answer.",
       //   });
       //
       //   print("final>$fulldata");
       // }

      //print("assistant$mymessage");

      return contentlength=="length"?fulldata:content;
    }
    return "";
    // else {
    //   return "Start chatting with us wrtie # with your Topic";
    // }

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
