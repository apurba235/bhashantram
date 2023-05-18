import 'package:bhashantram/app/data/network_client.dart';
import 'package:bhashantram/app/data/network_models/asr_translation_tts_response.dart';
import 'package:bhashantram/app/data/network_models/language_models.dart';

import '../network_models/transliteration_models.dart';
import '../network_models/transliteration_response.dart';

class BhashiniCalls extends NetworkClient {
  BhashiniCalls._();

  static BhashiniCalls instance = BhashiniCalls._();

  static const getModelsURL = 'https://meity-auth.ulcacontrib.org/ulca/apis/v0/model/getModelsPipeline';

  static const searchModelTransliteration = 'https://meity-auth.ulcacontrib.org/ulca/apis/v0/model/search';

  static const computeTransliterationUrl = 'https://meity-auth.ulcacontrib.org/ulca/apis/v0/model/compute';

  late Map<String, dynamic> computeHeader;

  var configHeader = {
    'userID': '965355806bf84442a8a168259ed8c06f',
    'ulcaApiKey': '4209d60edc-70e5-4b71-8427-c4665743e909'
  };

  void generateComputeHeader(String key, String value) {
    computeHeader = {'Accept': '*/*', 'User-Agent': ' Thunder Client (https://www.thunderclient.com)', key: value};
  }

  Future<LanguageModels?> getLanguages() async {
    Map<String, dynamic>? response = await postApi(
      getModelsURL,
      body: {
        "pipelineTasks": [
          {"taskType": "asr"},
          {"taskType": "translation"},
          {"taskType": "tts"}
        ],
        "pipelineRequestConfig": {"pipelineId": '64392f96daac500b55c543cd'}
      },
      header: configHeader,
      showResponse: false,
    );
    return (response == null) ? null : LanguageModels.fromJson(response);
  }

  /// only for Asr, Translation and Tts i.e. from audio generate translation in target language and generate speech in target language.
  Future<AsrTranslationTtsResponse?> computeAsrTranslationTts(String apiUrl, String sourceLang, String targetLang,
      String audioInput, String asrId, String translationId, String ttsId) async {
    Map<String, dynamic>? response = await postApi(
      apiUrl,
      body: {
        "pipelineTasks": [
          {
            "taskType": "asr",
            "config": {
              "language": {"sourceLanguage": sourceLang},
              "serviceId": asrId,
              "audioFormat": "wav",
              "samplingRate": 16000
            }
          },
          {
            "taskType": "translation",
            "config": {
              "language": {"sourceLanguage": sourceLang, "targetLanguage": targetLang},
              "serviceId": translationId
            }
          },
          {
            "taskType": "tts",
            "config": {
              "language": {"sourceLanguage": targetLang},
              "gender": "female",
              "serviceId": ttsId
            }
          }
        ],
        "inputData": {
          "audio": [
            {"audioContent": audioInput}
          ]
        }
      },
      header: computeHeader,
      showResponse: false,
    );
    return response == null ? null : AsrTranslationTtsResponse.fromJson(response);
  }

  Future<TransliterationModels?> getTransliterationModels() async {
    Map<String, dynamic>? response = await postApi(BhashiniCalls.searchModelTransliteration,
        body: {
          "task": "transliteration",
          "sourceLanguage": "",
          "targetLanguage": "",
          "domain": "All",
          "submitter": "All",
          "userId": null
        },
        showResponse: true);
    return response == null ? null : TransliterationModels.fromJson(response);
  }

  Future<TransliterationResponse?> computeTransliteration(String modelId, String input) async {
    Map<String, dynamic>? response = await postApi(
      BhashiniCalls.computeTransliterationUrl,
      body: {
        "modelId": modelId,
        "task": "transliteration",
        "input": [
          {"source": input}
        ]
      },
      showResponse: true,
    );
    return response == null ? null : TransliterationResponse.fromJson(response);
  }
}
