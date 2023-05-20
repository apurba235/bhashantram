import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChatModel {
  String message;
  String userType;
  String? audioPath;
  RxBool isPlaying;

  ChatModel({required this.message, required this.userType, this.audioPath, required this.isPlaying});
}
