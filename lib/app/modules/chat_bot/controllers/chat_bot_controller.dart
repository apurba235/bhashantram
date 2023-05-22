import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bhashantram/app/common/widget/snackbar/custom_snackbar.dart';
import 'package:bhashantram/app/data/network_models/asr_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/consts/app_url.dart';
import '../../../common/utils/language_code.dart';
import '../../../common/utils/permission_handler.dart';
import '../../../common/utils/voice_recorder.dart';
import '../../../data/api_calls/bhashini_calls.dart';
import '../../../data/network_models/language_models.dart';
import '../../../data/network_models/translation_models.dart';
import '../../../data/network_models/transliteration_models.dart';
import '../../../data/network_models/transliteration_response.dart';
import '../../../data/network_models/tts_models.dart';
import '../../../data/ui_models/chat_model.dart';
import 'package:http/http.dart' as http;

class ChatBotController extends GetxController {
  // chatbot code
  TextEditingController chatController = TextEditingController();
  String apiKey = AppUrl.chatApikey;
  // Rx<List<ChatMessage>> chats = Rx<List<ChatMessage>>([]);
  Rx<List<ChatModel>> conversations = Rx<List<ChatModel>>([]);
  final String reasonToStop = 'stop';
  // late String check = "-->";
  RxBool isLoad = RxBool(false);
  RxBool isLoading = false.obs;
  int previousPlayingIndex = -1;
  ScrollController languageScroll = ScrollController();

  Future<void> sendMessage([bool triggerPoint = false]) async {
    isLoad.value = true;
    String workingInput = chatController.text;
    chatController.clear();
    ChatModel newMessage = ChatModel(
      message: workingInput,
      userType: "user",
      audioPath: recordedAudioPath.isNotEmpty ? recordedAudioPath : null,
      isPlaying: false.obs,
      isComputeTTs: false.obs,
    );
    // ChatMessage message = ChatMessage(
    //   text: chatController.text,
    //   sender: "user",
    //   audioPath: recordedAudioPath.isNotEmpty ? recordedAudioPath : null,
    // );
    recordedAudioPath = '';
    conversations.value.insert(0, newMessage);
    // chats.value.insert(0, message);
    // chats.refresh();
    conversations.refresh();
    // bool checkTrue = false;
    // if (chatController.text.contains(check)) {
    // if (triggerPoint) {
    //   checkTrue = true;
    // } else {
    //   checkTrue = false;
    // }
    if (translationId.isNotEmpty) {
      botInput = await computeTranslation(workingInput, translationId, sourceLang.value ?? "", "en");
    } else {
      botInput = newMessage.message;
    }

    // log(chats.value.first.text, name: "check");
    // chatController.clear();
    // if (checkTrue) {
    //   botInput =  botInput;
    // }
    String response = "";
    response = await sendMessageToGpt(botInput, triggerPoint);
    if (responseToOutputTranslationId.isNotEmpty) {
      response = await computeTranslation(response, responseToOutputTranslationId, "en", sourceLang.value ?? "");
    }
    ChatModel botReply = ChatModel(message: response, userType: "bot", isPlaying: false.obs, isComputeTTs: false.obs);
    conversations.value.insert(0, botReply);
    conversations.refresh();
    // ChatMessage botMessage = ChatMessage(text: response, sender: "bot");
    // chats.value.insert(0, botMessage);
    isLoad.value = false;
    // chats.refresh();
    isLoad.refresh();
  }

  final List<Map<String, String>> myMessage = [];
  final List<String> finalList = [];

  Future sendMessageToGpt(String message, [bool isTriggered = false]) async {
    if (isTriggered) {
      myMessage.clear();
      myMessage.add({
        "role": "system",
        "content": "You are an Indian Citizen working with Government going to act like a very helpful assistant with all the knowledge that there is to offer about India."
            " You know everything there is to know about $message. You will be asked certain questions and you will respond very factually taking into context that the person asking the the questions is an Indian Citizen too."
            " Try to provide your answers concisely within word limit of not more than 30 words and using a single sentence. For each user prompt, check if the question given by the user has the context of current conversation, if not, please say: I do not know.",
      });

      myMessage.add({
        "role": "user",
        "content": message,
      });
    } else {
      myMessage.add({
        "role": "user",
        "content": "All your answers should be within the word limit of 60 words. My message is: $message.",
      });
    }

    dynamic response = await gptAPICall(myMessage);
    String contentToReturn = '';

    if (response.statusCode == 200) {
      Map<String, dynamic> parseResponse = json.decode(response.body);
      String finishReasonInResponse = parseResponse["choices"][0]["finish_reason"];
      contentToReturn = parseResponse["choices"][0]["message"]["content"];

      while (finishReasonInResponse != reasonToStop) {
        myMessage.add({"role": "assistant", "content": contentToReturn});
        myMessage.add({"role": "user", "content": 'Please complete the previous answer.'});

        response = await gptAPICall(myMessage);

        if (response.statusCode == 200) {
          parseResponse = json.decode(response.body);
          finishReasonInResponse = parseResponse["choices"][0]["finish_reason"];

          contentToReturn += ' ${parseResponse["choices"][0]["message"]["content"]}';
        }
      }
      contentToReturn = contentToReturn.trim();

      if (myMessage.length == 1) {
        contentToReturn += "\nPlease set the Topic in following manner:\n--> Topic_name";
      }

      myMessage.add({
        "role": "assistant",
        "content": contentToReturn,
      });

      return contentToReturn;
    }
    return "";
  }

  Future<dynamic> gptAPICall(List<Map<String, String>> messageQueue) async {
    var url = Uri.parse(AppUrl.chatUrl);
    log('Sending: $myMessage');

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": myMessage,
      "max_tokens": 60,
      "temperature": 0.6,
    };
    final response =
        await http.post(url, headers: {"Content-Type": "application/json", "api-key": apiKey}, body: json.encode(body));
    log(response.body);

    return response;
  }

  // end chatbot code

  /// Bhashini Api integration

  RxBool languageLoader = RxBool(false);
  Rxn<LanguageModels?> languages = Rxn<LanguageModels>();
  RxnString sourceLang = RxnString();
  int selectedSourceLangIndex = -1;
  Rxn<TransliterationModels?> transliterationModels = Rxn<TransliterationModels>();
  String transliterationModelsId = "";
  String transliterationInput = "";
  String topicTransliterationInput = "";
  Rxn<TransliterationResponse?> hints = Rxn<TransliterationResponse>();
  Rxn<TransliterationResponse?> topicHints = Rxn<TransliterationResponse>();
  Rxn<TranslationResponse?> translatedResponse = Rxn<TranslationResponse>();
  String botInput = '';
  String computeUrl = '';
  String computeApiKey = '';
  String computeApiValue = '';
  String translationInput = '';
  String translationId = '';
  String asrServiceId = '';
  String ttsId = '';
  String responseToOutputTranslationId = '';
  bool isMicPermissionGranted = false;
  final VoiceRecorder _voiceRecorder = VoiceRecorder();
  int samplingRate = 8000;
  RxBool recordingOngoing = RxBool(false);
  RxBool topicRecordingOngoing = RxBool(false);
  String encodedAudio = '';
  String topicEncodedAudio = '';
  String recordedAudioPath = '';
  Rxn<AsrResponse?> asrResponse = Rxn<AsrResponse?>();
  final PlayerController _playerController = PlayerController();
  Rxn<TtsResponse?> ttsResponse = Rxn<TtsResponse>();
  String ttsFilePath = '';
  RxBool asrOngoing = RxBool(false);
  RxBool topicAsrOngoing = RxBool(false);
  RxnString topicName = RxnString();
  TextEditingController topicController = TextEditingController();

  Future<void> getLanguages() async {
    languageLoader.value = true;
    LanguageModels? response = await BhashiniCalls.instance.getLanguages();
    if (response != null) {
      languages.value = response;
    }
    languageLoader.value = false;
  }

  String getLanguageName(String code) => LanguageCode.languageCode.entries
      .firstWhere((element) => element.key == code, orElse: () => MapEntry('', code))
      .value;

  void computeApiData() {
    computeUrl = languages.value?.pipelineInferenceAPIEndPoint?.callbackUrl ?? '';
    computeApiKey = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.name ?? '';
    computeApiValue = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.value ?? '';
    BhashiniCalls.instance.generateComputeHeader(computeApiKey, computeApiValue);
  }

  void getAsrAndTtsServiceId() {
    asrServiceId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'asr')
            .config
            ?.firstWhere((e) => e.language?.sourceLanguage?.contains(sourceLang) ?? false)
            .serviceId ??
        "";
    ttsId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'tts')
            .config
            ?.firstWhere((e) => (e.language?.sourceLanguage?.contains(sourceLang) ?? false))
            .serviceId ??
        "";
  }

  void getTranslationId() {
    translationId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'translation')
            .config
            ?.firstWhere((e) => ((e.language?.sourceLanguage?.contains(sourceLang) ?? false) &&
                (e.language?.targetLanguage?.contains('en') ?? false)))
            .serviceId ??
        "";
  }

  Future<void> getTransliterationModels() async {
    TransliterationModels? response = await BhashiniCalls.instance.getTransliterationModels();
    if (response != null) {
      transliterationModels.value = response;
    }
  }

  Future<void> computeTransliteration([bool fromTopic = false]) async {
    TransliterationResponse? response =
        await BhashiniCalls.instance.computeTransliteration(transliterationModelsId, fromTopic ? topicTransliterationInput :transliterationInput);
    if (response != null) {
      if(fromTopic){
        topicHints.value = response;
      }else{
        hints.value = response;
      }
    }
    // hints.value?.output?.first.target?.forEach((element) {
    //   log(element, name: 'Hints');
    // });
  }

  void getTransliterationModelId() {
    transliterationModelsId = transliterationModels.value?.data
            ?.firstWhere(
              (element) => ((element.languages?.first.sourceLanguage == 'en') &&
                  (element.languages?.first.targetLanguage == sourceLang.value)),
              orElse: () => Data(modelId: ''),
            )
            .modelId ??
        '';
    log(transliterationModelsId, name: 'Transliteration Model Id');
  }

  void getTransliterationInput([bool fromTopic = false, String topicInput = '']) {
    int index = 0;
    if(fromTopic){
      for (int i = topicInput.length - 1; i >= 0; i--) {
        if (topicInput[i].contains(RegExp('[^A-Za-z]'))) {
          index = i + 1;
          break;
        }
      }
      topicTransliterationInput = topicInput.substring(index);
    }else{
      for (int i = chatController.text.length - 1; i >= 0; i--) {
        if (chatController.text[i].contains(RegExp('[^A-Za-z]'))) {
          index = i + 1;
          break;
        }
      }
      transliterationInput = chatController.text.substring(index);
    }
  }

  Future<void> computeAsr([bool fromDialog = false]) async {
    if(fromDialog){
      topicAsrOngoing.value = true;
    }else{
      asrOngoing.value = true;
    }
    String workingAudio = fromDialog ? topicEncodedAudio : encodedAudio;
    AsrResponse? response =
        await BhashiniCalls.instance.computeAsr(computeUrl, sourceLang.value ?? '', asrServiceId, workingAudio);
    if (response != null) {
      asrResponse.value = response;
    }
    if(fromDialog){
      if(asrResponse.value?.pipelineResponse?.first.output?.first.source?.isNotEmpty ?? false){
        topicName.value = asrResponse.value?.pipelineResponse?.first.output?.first.source ?? '';
        topicController.text = topicName.value ?? '';
      }else{
        showSnackBar('Please speak properly');
      }
    }else{
      if(asrResponse.value?.pipelineResponse?.first.output?.first.source?.isNotEmpty ?? false){
        chatController.text = asrResponse.value?.pipelineResponse?.first.output?.first.source ?? '';
      }else{
        recordedAudioPath = '';
      }
    }

    if(fromDialog){
      topicEncodedAudio = '';
      topicAsrOngoing.value = false;
    }else{
      encodedAudio = '';
      asrOngoing.value = false;
    }
  }

  Future<String> computeTranslation(String input, String serviceId, String source, String target) async {
    TranslationResponse? response =
        await BhashiniCalls.instance.computeTranslation(computeUrl, source, target, input, serviceId);
    if (response != null) {
      translatedResponse.value = response;
    }
    return translatedResponse.value?.pipelineResponse?.first.output?.first.target ?? '';
  }

  void getResponseToOutputTranslationId() {
    responseToOutputTranslationId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'translation')
            .config
            ?.firstWhere((e) => ((e.language?.sourceLanguage?.contains('en') ?? false) &&
                (e.language?.targetLanguage?.contains(sourceLang.value ?? '') ?? false)))
            .serviceId ??
        "";
  }

  Future<void> startRecording([bool fromDialog = false]) async {
    await PermissionHandler.requestPermissions().then((result) {
      isMicPermissionGranted = result;
    });
    if (isMicPermissionGranted) {
      if(fromDialog){
        topicRecordingOngoing.value = true;
      }else{
        recordingOngoing.value = true;
      }
      await _voiceRecorder.startRecordingVoice(samplingRate);
    }
  }

  Future<void> stopRecordingAndGetResult([bool fromDialog = false]) async {
    if(fromDialog){
      topicEncodedAudio = await _voiceRecorder.stopRecordingVoiceAndGetOutput() ?? '';
      topicRecordingOngoing.value = false;
    }else{
      recordingOngoing.value = false;
      encodedAudio = await _voiceRecorder.stopRecordingVoiceAndGetOutput() ?? '';
      recordedAudioPath = _voiceRecorder.getAudioFilePath() ?? '';
    }
  }

  Future<void> playRecordedAudio(String filePath) async {
    log(filePath, name: 'AudioFile');
    if (_playerController.playerState == PlayerState.playing || _playerController.playerState == PlayerState.paused) {
      await _playerController.stopPlayer();
    }
    await _playerController.preparePlayer(
      path: filePath,
      shouldExtractWaveform: false,
    );
    await _playerController.startPlayer(finishMode: FinishMode.pause);
    await Future.delayed(Duration(milliseconds: _playerController.maxDuration));
  }

  Future<void> stopPlayer() async{
    await _playerController.stopPlayer();
  }

  Future<void> computeTts(String input, int index) async {
    conversations.value[index].isComputeTTs.value = true;
    TtsResponse? response =
    await BhashiniCalls.instance.generateTTS(computeUrl, sourceLang.value ?? '',  input, ttsId);
    if (response != null) {
      ttsResponse.value = response;
    }
    String audioTts = response?.pipelineResponse?.first.audio?.first.audioContent ?? '';
    await writeTTsAudio(audioTts, index);
    conversations.value[index].isComputeTTs.value = false;
  }

  Future<void> writeTTsAudio(String audioContent, int index) async {
    Uint8List? fileAsBytes = base64Decode(audioContent);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String recordingPath = '${appDocDir.path}/recordings';
    if (!await Directory(recordingPath).exists()) {
      Directory(recordingPath).create();
    }
    ttsFilePath = '$recordingPath/TTSAudio${DateTime.now().millisecondsSinceEpoch}.wav';
    File? ttsAudioFile = File(ttsFilePath);
    await ttsAudioFile.writeAsBytes(fileAsBytes);
    conversations.value[index].audioPath = ttsAudioFile.path;
  }

  @override
  void onInit() async {
    await PermissionHandler.requestPermissions().then((result) {
      isMicPermissionGranted = result;
    });
    await getLanguages();
    computeApiData();
    await getTransliterationModels();
    await _voiceRecorder.clearOldRecordings();
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

  @override
  InternalFinalCallback<void> get onDelete {
     stopPlayer();
    return super.onDelete;
  }

  @override
  void dispose() async{
    await stopPlayer();
    super.dispose();
  }
}
