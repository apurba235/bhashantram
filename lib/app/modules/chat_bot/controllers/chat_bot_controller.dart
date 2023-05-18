import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../common/consts/app_url.dart';
import '../../../common/utils/language_code.dart';
import '../../../data/api_calls/bhashini_calls.dart';
import '../../../data/network_models/language_models.dart';
import '../views/chat_message.dart';
import 'package:http/http.dart' as http;


class ChatBotController extends GetxController {

  // chatbot code
   TextEditingController chatController = TextEditingController();
   String apiKey = AppUrl.chatApikey;
   Rx<List<ChatMessage>> chats = Rx<List<ChatMessage>>([]);
   late String content;
   late String contentlength;
   late String check="-->";
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
   final List<String>finallist=[];
   Future<String> sendMessageToGpt(String message)async{
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
     log('mylog>$mymessage');

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

       content=  parseResponse["choices"][0]["message"]["content"];
       contentlength=parseResponse["choices"][0]["finish_reason"];
       log("contentLength>>$contentlength");
       content=content.trim();
       if(mymessage.length==1){
         content+="\n\n Please set the Topic in following manner :\n --> Topic_name";

       }
         mymessage.add({
         "role":"assistant",
         "content":content,
         });
       // finallist.add(content);
       //
       //
       if(contentlength=='length'){
         mymessage.add({
         "role":"assistant",
         "content":content,
         });
         mymessage.add({
         "role":"user",
         "content":"$message Please compelete the previous answer.",
         });

       }
      await sendMessageToGpt(message);




       return content;
     }
     return "";


   }

   // end chatbot code




   // language controler code

   RxBool languageLoader = RxBool(false);
   Rxn<LanguageModels?> languages = Rxn<LanguageModels>();
   List<String> sourceLanguages = [];
   RxnString sourceLang = RxnString();
   RxnString targetLang = RxnString();
   int selectedSourceLangIndex = -1;
   int selectedTargetLangIndex = -1;

   Future<void> getLanguages() async {
     languageLoader.value = true;
     LanguageModels? response = await BhashiniCalls.instance.getLanguages();
     if (response != null) {
       languages.value = response;
     }
     // else {
     //   await showSnackBar();
     // }
     languageLoader.value = false;
   }
   String getLanguageName(String code) => LanguageCode.languageCode.entries
       .firstWhere((element) => element.key == code, orElse: () => MapEntry('', code))
       .value;
    //end language controoler code






  @override
  void onInit() async{
    await getLanguages();

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
