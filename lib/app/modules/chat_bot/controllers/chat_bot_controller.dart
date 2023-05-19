import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/consts/app_url.dart';
import '../../../common/utils/language_code.dart';
import '../../../common/utils/permission_handler.dart';
import '../../../common/utils/voice_recorder.dart';
import '../../../data/api_calls/bhashini_calls.dart';
import '../../../data/network_models/asr_translation_tts_response.dart';
import '../../../data/network_models/language_models.dart';
import '../../../data/network_models/translation_models.dart';
import '../../../data/network_models/transliteration_models.dart';
import '../../../data/network_models/transliteration_response.dart';
import '../views/chat_message.dart';
import 'package:http/http.dart' as http;

class ChatBotController extends GetxController {
  // chatbot code
  TextEditingController chatController = TextEditingController();
  String apiKey = AppUrl.chatApikey;
  Rx<List<ChatMessage>> chats = Rx<List<ChatMessage>>([]);
  final String reasonToStop = 'stop';
  late String check = "-->";
  RxBool isLoad = RxBool(false);
  var isloading = false.obs;

  Future<void> sendMessage() async {
    isLoad.value = true;
    ChatMessage message =
        ChatMessage(text: chatController.text, sender: "user");

    chats.value.insert(0, message);
    chats.refresh();
    await computeTranslation();
    log(chats.value.first.text, name: "check");
    chatController.clear();
    final response = await sendMessageToGpt(botInput);
    ChatMessage botMessage = ChatMessage(text: response, sender: "bot");
    chats.value.insert(0, botMessage);
    isLoad.value = false;
    chats.refresh();
    isLoad.refresh();
  }

  final List<Map<String, String>> mymessage = [];
  final List<String> finallist = [];

  Future sendMessageToGpt(String message) async {
    if (message.contains(check)) {
      mymessage.clear();
      mymessage.add({
        "role": "system",
        "content": "You are an Indian Citizen working with Government going to act like a very helpful assistant with all the knowledge that there is to offer about India."
            " You know everything there is to know about $message. You will be asked certain questions and you will respond very factually taking into context that the person asking the the questions is an Indian Citizen too."
            " Try to provide your answers concisely within word limit of not more than 30 words and using a single sentence. For each user prompt, check if the question given by the user has the context of current conversation, if not, please say: I do not know.",
      });

      mymessage.add({
        "role": "user",
        "content": message,
      });
    } else {
      mymessage.add({
        "role": "user",
        "content":
            "All your answers should be within the word limit of 60 words. My message is: $message.",
      });
    }

    dynamic response = await gptAPICall(mymessage);
    String contentToReturn = '';

    if (response.statusCode == 200) {
      Map<String, dynamic> parseResponse = json.decode(response.body);
      String finishReasonInResponse =
          parseResponse["choices"][0]["finish_reason"];
      contentToReturn = parseResponse["choices"][0]["message"]["content"];

      while (finishReasonInResponse != reasonToStop) {
        mymessage.add({"role": "assistant", "content": contentToReturn});
        mymessage.add({
          "role": "user",
          "content": 'Please complete the previous answer.'
        });

        response = await gptAPICall(mymessage);

        if (response.statusCode == 200) {
          parseResponse = json.decode(response.body);
          finishReasonInResponse = parseResponse["choices"][0]["finish_reason"];

          contentToReturn +=
              ' ${parseResponse["choices"][0]["message"]["content"]}';
        }
      }
      contentToReturn = contentToReturn.trim();

      if (mymessage.length == 1) {
        contentToReturn +=
            "\nPlease set the Topic in following manner:\n--> Topic_name";
      }

      mymessage.add({
        "role": "assistant",
        "content": contentToReturn,
      });

      return contentToReturn;
    }
    return "";
  }

  Future<dynamic> gptAPICall(List<Map<String, String>> messageQueue) async {
    var url = Uri.parse(AppUrl.chatUrl);
    log('Sending: $mymessage');

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": mymessage,
      "max_tokens": 60,
      "temperature": 0.6,
    };
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "api-key": apiKey},
        body: json.encode(body));
    log(response.body);

    return response;
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
      .firstWhere((element) => element.key == code,
          orElse: () => MapEntry('', code))
      .value;

  //end language controoler code

  /// Bhashini Api integration

  Rxn<TransliterationModels?> transliterationModels =
      Rxn<TransliterationModels>();
  String transliterationModelsId = "";
  String transliterationInput = "";
  Rxn<TransliterationResponse?> hints = Rxn<TransliterationResponse>();
  Rxn<TranslationResponse?> translatedResponse = Rxn<TranslationResponse>();
  String botInput = '';
  String computeTranslationUrl = '';
  String computeApiKey = '';
  String computeApiValue = '';
  String translationInput = '';
  String translationId = '';

  void computeApiData() {
    computeTranslationUrl = languages.value?.pipelineInferenceAPIEndPoint?.callbackUrl ?? '';
    computeApiKey = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.name ?? '';
    computeApiValue = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.value ?? '';
    BhashiniCalls.instance.generateComputeHeader(computeApiKey, computeApiValue);
  }

  void getTranslationId(){
    translationId = languages.value?.pipelineResponseConfig
        ?.firstWhere((element) => element.taskType == 'translation')
        .config
        ?.firstWhere((e) => ((e.language?.sourceLanguage?.contains(sourceLang) ?? false) &&
        (e.language?.targetLanguage?.contains('en') ?? false)))
        .serviceId ??
        "";
  }

  Future<void> getTransliterationModels() async {
    TransliterationModels? response =
        await BhashiniCalls.instance.getTransliterationModels();
    if (response != null) {
      transliterationModels.value = response;
    }
  }

  Future<void> computeTransliteration() async {
    TransliterationResponse? response = await BhashiniCalls.instance
        .computeTransliteration(transliterationModelsId, transliterationInput);
    if (response != null) {
      hints.value = response;
    }
    hints.value?.output?.first.target?.forEach((element) {
      log(element, name: 'Hints');
    });
  }

  void getTransliterationModelId() {
    transliterationModelsId = transliterationModels.value?.data
            ?.firstWhere(
              (element) => ((element.languages?.first.sourceLanguage == 'en') &&
                  (element.languages?.first.targetLanguage ==
                      sourceLang.value)),
              orElse: () => Data(modelId: ''),
            )
            .modelId ??
        '';
    log(transliterationModelsId, name: 'Transliteration Model Id');
  }

  void getTransliterationInput() {
    int index = 0;
    for (int i = chatController.text.length - 1; i >= 0; i--) {
      if (chatController.text[i].contains(RegExp('[^A-Za-z]'))) {
        index = i + 1;
        break;
      }
    }
    transliterationInput = chatController.text.substring(index);
  }

  Future<void> computeTranslation() async {
    TranslationResponse? response = await BhashiniCalls.instance
        .computeTranslation(computeTranslationUrl, sourceLang.value ?? '', 'en', chatController.text, translationId);
    if (response != null) {
      translatedResponse.value = response;
    }
    botInput = translatedResponse.value?.pipelineResponse?.first.output?.first.target ?? '';
    log(botInput,name: "translation");
  }

  // // Translation Api call
  // Rxn<AsrTranslationTtsResponse?> asrTranslationTts = Rxn<AsrTranslationTtsResponse>();
  // String asrServiceId = "";
  // // String translationId = "";
  // String ttsId = "";
  // String workingSource = '';
  // String workingTarget = '';
  // RxnString input = RxnString();
  // RxnString output = RxnString();
  // bool fromTarget = false;
  // final PlayerController _playerController = PlayerController();
  // String recordedAudioPath = '';
  // // RxBool playingAudio = RxBool(false);
  // RxBool inputAudioPlay = RxBool(false);
  // RxBool outputAudioPlay = RxBool(false);
  // final VoiceRecorder _voiceRecorder = VoiceRecorder();
  // int samplingRate = 8000;
  // RxBool recordingOngoing = RxBool(false);
  // String encodedAudio = '';
  // String ttsFilePath = '';
  // String inputAudioPath = '';
  // String outputAudioPath = '';
  // String computeURL = '';
  // // String computeApiKey = '';
  // // String computeApiValue = '';
  // bool isMicPermissionGranted = false;
  //
  //
  // Future<void> computeAsrTranslationTts() async {
  //   languageLoader.value = true;
  //   AsrTranslationTtsResponse? response = await BhashiniCalls.instance.computeAsrTranslationTts(
  //       computeURL, workingSource, workingTarget, encodedAudio, asrServiceId, translationId, ttsId);
  //   if (response != null) {
  //     asrTranslationTts.value = response;
  //   }
  //   languageLoader.value = false;
  //   if (fromTarget) {
  //     input.value = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'translation')
  //         .output
  //         ?.first
  //         .target ??
  //         '';
  //     output.value = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'translation')
  //         .output
  //         ?.first
  //         .source ??
  //         '';
  //     String generatedAudio = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'tts')
  //         .audio
  //         ?.first
  //         .audioContent ??
  //         '';
  //     await writeTTsAudio(generatedAudio, true);
  //     outputAudioPath = recordedAudioPath;
  //     log(inputAudioPath, name: 'input');
  //     playRecordedAudio(inputAudioPath, true);
  //   } else {
  //     output.value = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'translation')
  //         .output
  //         ?.first
  //         .target ??
  //         '';
  //     input.value = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'translation')
  //         .output
  //         ?.first
  //         .source ??
  //         '';
  //     String generatedAudio = asrTranslationTts.value?.pipelineResponse
  //         ?.firstWhere((element) => element.taskType == 'tts')
  //         .audio
  //         ?.first
  //         .audioContent ??
  //         '';
  //     await writeTTsAudio(generatedAudio, false);
  //     inputAudioPath = recordedAudioPath;
  //     playRecordedAudio(outputAudioPath, false);
  //   }
  // }
  //
  // Future<void> workingData() async {
  //   if (fromTarget) {
  //     workingSource = targetLang.value ?? '';
  //     workingTarget = sourceLang.value ?? '';
  //   } else {
  //     workingSource = sourceLang.value ?? '';
  //     workingTarget = targetLang.value ?? '';
  //   }
  //   getAsrServiceId();
  //   getTranslationAndTtsId();
  // }
  //
  // void computeApiData() {
  //   computeURL = languages.value?.pipelineInferenceAPIEndPoint?.callbackUrl ?? '';
  //   computeApiKey = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.name ?? '';
  //   computeApiValue = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.value ?? '';
  //   BhashiniCalls.instance.generateComputeHeader(computeApiKey, computeApiValue);
  // }
  //
  // void getAsrServiceId() {
  //   asrServiceId = languages.value?.pipelineResponseConfig
  //       ?.firstWhere((element) => element.taskType == 'asr')
  //       .config
  //       ?.firstWhere((e) => e.language?.sourceLanguage?.contains(workingSource) ?? false)
  //       .serviceId ??
  //       "";
  //   log(asrServiceId, name: 'Asr Service  ID');
  // }
  //
  // void getTranslationAndTtsId() {
  //   translationId = languages.value?.pipelineResponseConfig
  //       ?.firstWhere((element) => element.taskType == 'translation')
  //       .config
  //       ?.firstWhere((e) => ((e.language?.sourceLanguage?.contains(workingSource) ?? false) &&
  //       (e.language?.targetLanguage?.contains(workingTarget) ?? false)))
  //       .serviceId ??
  //       "";
  //   ttsId = languages.value?.pipelineResponseConfig
  //       ?.firstWhere((element) => element.taskType == 'tts')
  //       .config
  //       ?.firstWhere((e) => (e.language?.sourceLanguage?.contains(workingTarget) ?? false))
  //       .serviceId ??
  //       "";
  //   log(translationId, name: 'Translation Service  ID');
  //   log(ttsId, name: 'TTS Service  ID');
  // }
  //
  //
  // Future<void> startRecording() async {
  //   await PermissionHandler.requestPermissions().then((result) {
  //     isMicPermissionGranted = result;
  //   });
  //   if (isMicPermissionGranted) {
  //     recordingOngoing.value = true;
  //     await _voiceRecorder.startRecordingVoice(samplingRate);
  //   }
  // }
  //
  // Future<void> stopRecordingAndGetResult() async {
  //   recordingOngoing.value = false;
  //   encodedAudio = await _voiceRecorder.stopRecordingVoiceAndGetOutput() ?? '';
  //   recordedAudioPath = _voiceRecorder.getAudioFilePath()??'';
  // }
  //
  // Future<void> playRecordedAudio(String filePath, bool inputAudio) async {
  //   log(filePath, name: 'AudioFile');
  //   if(inputAudio){
  //     inputAudioPlay.value = true;
  //   }else{
  //     outputAudioPlay.value = true;
  //   }
  //   // playingAudio.value = true;
  //   if (_playerController.playerState == PlayerState.playing || _playerController.playerState == PlayerState.paused) {
  //     await _playerController.stopPlayer();
  //   }
  //   await _playerController.preparePlayer(
  //     path: filePath,
  //     shouldExtractWaveform: false,
  //   );
  //   await _playerController.startPlayer(finishMode: FinishMode.pause);
  //   await Future.delayed(Duration(milliseconds: _playerController.maxDuration));
  //   // playingAudio.value = false;
  //   if(inputAudio){
  //     inputAudioPlay.value = false;
  //   }else{
  //     outputAudioPlay.value = false;
  //   }
  // }
  //
  // Future<void> writeTTsAudio(String audioContent, bool fromTarget) async {
  //   Uint8List? fileAsBytes = base64Decode(audioContent);
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String recordingPath = '${appDocDir.path}/recordings';
  //   if (!await Directory(recordingPath).exists()) {
  //     Directory(recordingPath).create();
  //   }
  //   if(fromTarget){
  //     inputAudioPath = '$recordingPath/TTSAudio${DateTime.now().millisecondsSinceEpoch}.wav';
  //     File? ttsAudioFile = File(inputAudioPath);
  //     await ttsAudioFile.writeAsBytes(fileAsBytes);
  //   }else{
  //     outputAudioPath = '$recordingPath/TTSAudio${DateTime.now().millisecondsSinceEpoch}.wav';
  //     File? ttsAudioFile = File(outputAudioPath);
  //     await ttsAudioFile.writeAsBytes(fileAsBytes);
  //   }
  // }
  //
  // Future<void> computeTranslation() async {
  //   TranslationResponse? response = await BhashiniCalls.instance
  //       .computeTranslation(computeTranslationUrl, sourceLang.value ?? '', 'en', translationInput, translationId);
  //   if (response != null) {
  //     translatedResponse.value = response;
  //   }
  //   botInput = translatedResponse.value?.pipelineResponse?.first.output?.first.target ?? '';
  // }



  @override
  void onInit() async {
    await getLanguages();
    computeApiData();
    await getTransliterationModels();

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
