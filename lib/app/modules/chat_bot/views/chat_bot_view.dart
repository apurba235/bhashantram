import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
   ChatBotView({Key? key}) : super(key: key);

  List<String> myList = ["English","Tamil","Kanada","Gujrati","Hindi"];



   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leadingWidth: 30,
        leading:    BackButton(
          color: Colors.black,
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ChatGPT",style: TextStyle(fontSize: 16,color: Colors.black),),
                Row(
                  children: [
                    Icon(Icons.circle,color: Color(0xff00E173),size: 12,),
                    SizedBox(width: 5,),
                    Text("Online",style: TextStyle(fontSize: 12,color:Color(0xff00E173) )),
                  ],

                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder: buildBottomSheet,
                shape: const RoundedRectangleBorder( // <-- SEE HERE
                borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
                ),));

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Language",style: TextStyle
                        (
                          fontSize: 12,color: Colors.black
                      ),),
                      Icon(Icons.arrow_drop_down,color: Color(0xff00E173),)
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
      body:Column(
        children: [
          Flexible(
            child:
            ListView.builder(
              reverse: true,
              itemBuilder: (context, index)
            {

            },
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30,left: 10,right: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),

              elevation: 10,
              child: Container(
                child: _buidTextComposer(),
              ),
            ),
          ),


        ],
      )

    );
  }
  Widget buildBottomSheet(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Center(child: Text("Select Language",style: TextStyle(fontSize: 16,color: Color(0xff3080ED)),)),
        Container(
          height: MediaQuery.of(context).size.height/2.2,
          child: ListView.builder(
            padding: EdgeInsets.all(40),
            itemBuilder: (context, index,) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Text(myList[index],style:TextStyle(fontSize: 12,color: Color(0xff3080ED))),
                SizedBox(height: 15,),
                Divider(
                    color: Color(0xff3080ED)
                )
              ],
            );

          },itemCount: myList.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40,right: 40),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade100,

            ),
            height: 40,
            child: Center(
                child: Text("Select",style:TextStyle(fontSize: 20,color: Colors.white))),
          ),
        ),
      ],
    );
  }
   Widget _buidTextComposer() {
     return
       Padding(
         padding: const EdgeInsets.only(left: 15,right: 15),
         child: Row(
           children: [
             Expanded(
               child:
               TextField(
           decoration: InputDecoration.collapsed(hintText: "Hello ChatGPT!",hintStyle:TextStyle(fontSize: 16,color: Color(0xff3080ED))), ), ),
         IconButton(onPressed: () {
          // _sendMessage();
         }, icon: Icon(Icons.mic,color: Color(0xffB6B6B6),)), IconButton(onPressed: () {
          // _sendMessage();
         }, icon: Icon(Icons.send,color: Color(0xff3080ED),)),
     ], ),
       );
   }


}
