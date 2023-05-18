import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/utils/language_code.dart';
import '../../../common/utils/permission_handler.dart';
import '../../../common/utils/voice_recorder.dart';
import '../../../data/api_calls/bhashini_calls.dart';
import '../../../data/network_models/asr_translation_tts_response.dart';
import '../../../data/network_models/language_models.dart';

class ConverseController extends GetxController {
  RxBool languageLoader = RxBool(false);
  Rxn<LanguageModels?> languages = Rxn<LanguageModels>();
  Rxn<AsrTranslationTtsResponse?> asrTranslationTts = Rxn<AsrTranslationTtsResponse>();
  List<String> sourceLanguages = [];
  RxnString sourceLang = RxnString();
  RxnString targetLang = RxnString();
  int selectedSourceLangIndex = -1;
  int selectedTargetLangIndex = -1;
  bool isMicPermissionGranted = false;
  final VoiceRecorder _voiceRecorder = VoiceRecorder();
  int samplingRate = 8000;
  RxBool recordingOngoing = RxBool(false);
  String encodedAudio = '';
  String ttsFilePath = '';
  String inputAudioPath = '';
  String outputAudioPath = '';
  String computeURL = '';
  String computeApiKey = '';
  String computeApiValue = '';
  String asrServiceId = "";
  String translationId = "";
  String ttsId = "";
  String workingSource = '';
  String workingTarget = '';
  RxnString input = RxnString();
  RxnString output = RxnString();
  bool fromTarget = false;
  final PlayerController _playerController = PlayerController();
  String recordedAudioPath = '';
  // RxBool playingAudio = RxBool(false);
  RxBool inputAudioPlay = RxBool(false);
  RxBool outputAudioPlay = RxBool(false);

  Future<void> workingData() async {
    if (fromTarget) {
      workingSource = targetLang.value ?? '';
      workingTarget = sourceLang.value ?? '';
    } else {
      workingSource = sourceLang.value ?? '';
      workingTarget = targetLang.value ?? '';
    }
    getAsrServiceId();
    getTranslationAndTtsId();
  }

  void computeApiData() {
    computeURL = languages.value?.pipelineInferenceAPIEndPoint?.callbackUrl ?? '';
    computeApiKey = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.name ?? '';
    computeApiValue = languages.value?.pipelineInferenceAPIEndPoint?.inferenceApiKey?.value ?? '';
    BhashiniCalls.instance.generateComputeHeader(computeApiKey, computeApiValue);
  }

  void getAsrServiceId() {
    asrServiceId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'asr')
            .config
            ?.firstWhere((e) => e.language?.sourceLanguage?.contains(workingSource) ?? false)
            .serviceId ??
        "";
    log(asrServiceId, name: 'Asr Service  ID');
  }

  void getTranslationAndTtsId() {
    translationId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'translation')
            .config
            ?.firstWhere((e) => ((e.language?.sourceLanguage?.contains(workingSource) ?? false) &&
                (e.language?.targetLanguage?.contains(workingTarget) ?? false)))
            .serviceId ??
        "";
    ttsId = languages.value?.pipelineResponseConfig
            ?.firstWhere((element) => element.taskType == 'tts')
            .config
            ?.firstWhere((e) => (e.language?.sourceLanguage?.contains(workingTarget) ?? false))
            .serviceId ??
        "";
    log(translationId, name: 'Translation Service  ID');
    log(ttsId, name: 'TTS Service  ID');
  }

  Future<void> getLanguages() async {
    languageLoader.value = true;
    LanguageModels? response = await BhashiniCalls.instance.getLanguages();
    if (response != null) {
      languages.value = response;
    }
    languageLoader.value = false;
  }

  Future<void> computeAsrTranslationTts() async {
    languageLoader.value = true;
    AsrTranslationTtsResponse? response = await BhashiniCalls.instance.computeAsrTranslationTts(
        computeURL, workingSource, workingTarget, encodedAudio, asrServiceId, translationId, ttsId);
    if (response != null) {
      asrTranslationTts.value = response;
    }
    languageLoader.value = false;
    if (fromTarget) {
      input.value = asrTranslationTts.value?.pipelineResponse
              ?.firstWhere((element) => element.taskType == 'translation')
              .output
              ?.first
              .target ??
          '';
      output.value = asrTranslationTts.value?.pipelineResponse
              ?.firstWhere((element) => element.taskType == 'translation')
              .output
              ?.first
              .source ??
          '';
      String generatedAudio = asrTranslationTts.value?.pipelineResponse
          ?.firstWhere((element) => element.taskType == 'tts')
          .audio
          ?.first
          .audioContent ??
          '';
      await writeTTsAudio(generatedAudio, true);
      outputAudioPath = recordedAudioPath;
      log(inputAudioPath, name: 'input');
      playRecordedAudio(inputAudioPath, true);
    } else {
      output.value = asrTranslationTts.value?.pipelineResponse
              ?.firstWhere((element) => element.taskType == 'translation')
              .output
              ?.first
              .target ??
          '';
      input.value = asrTranslationTts.value?.pipelineResponse
              ?.firstWhere((element) => element.taskType == 'translation')
              .output
              ?.first
              .source ??
          '';
      String generatedAudio = asrTranslationTts.value?.pipelineResponse
          ?.firstWhere((element) => element.taskType == 'tts')
          .audio
          ?.first
          .audioContent ??
          '';
      await writeTTsAudio(generatedAudio, false);
      inputAudioPath = recordedAudioPath;
      playRecordedAudio(outputAudioPath, false);
    }
  }

  Future<void> writeTTsAudio(String audioContent, bool fromTarget) async {
    Uint8List? fileAsBytes = base64Decode(audioContent);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String recordingPath = '${appDocDir.path}/recordings';
    if (!await Directory(recordingPath).exists()) {
      Directory(recordingPath).create();
    }
    if(fromTarget){
      inputAudioPath = '$recordingPath/TTSAudio${DateTime.now().millisecondsSinceEpoch}.wav';
      File? ttsAudioFile = File(inputAudioPath);
      await ttsAudioFile.writeAsBytes(fileAsBytes);
    }else{
      outputAudioPath = '$recordingPath/TTSAudio${DateTime.now().millisecondsSinceEpoch}.wav';
      File? ttsAudioFile = File(outputAudioPath);
      await ttsAudioFile.writeAsBytes(fileAsBytes);
    }
  }

  String getLanguageName(String code) => LanguageCode.languageCode.entries
      .firstWhere((element) => element.key == code, orElse: () => MapEntry('', code))
      .value;

  Future<void> startRecording() async {
    await PermissionHandler.requestPermissions().then((result) {
      isMicPermissionGranted = result;
    });
    if (isMicPermissionGranted) {
      recordingOngoing.value = true;
      await _voiceRecorder.startRecordingVoice(samplingRate);
    }
  }

  Future<void> stopRecordingAndGetResult() async {
    recordingOngoing.value = false;
    encodedAudio = await _voiceRecorder.stopRecordingVoiceAndGetOutput() ?? '';
    recordedAudioPath = _voiceRecorder.getAudioFilePath()??'';
  }

  Future<void> playRecordedAudio(String filePath, bool inputAudio) async {
    log(filePath, name: 'AudioFile');
    if(inputAudio){
      inputAudioPlay.value = true;
    }else{
      outputAudioPlay.value = true;
    }
    // playingAudio.value = true;
    if (_playerController.playerState == PlayerState.playing || _playerController.playerState == PlayerState.paused) {
      await _playerController.stopPlayer();
    }
    await _playerController.preparePlayer(
      path: filePath,
      shouldExtractWaveform: false,
    );
    await _playerController.startPlayer(finishMode: FinishMode.pause);
    await Future.delayed(Duration(milliseconds: _playerController.maxDuration));
    // playingAudio.value = false;
    if(inputAudio){
      inputAudioPlay.value = false;
    }else{
      outputAudioPlay.value = false;
    }
  }

  @override
  void onInit() async {
    await getLanguages();
    computeApiData();
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
}
