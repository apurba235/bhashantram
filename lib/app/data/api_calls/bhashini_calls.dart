import 'package:bhashantram/app/data/network_client.dart';
import 'package:bhashantram/app/data/network_models/network_models.dart';

class BhashiniCalls extends NetworkClient {
  BhashiniCalls._();

  static BhashiniCalls instance = BhashiniCalls._();

  static const getModelsURL = 'https://meity-auth.ulcacontrib.org/ulca/apis/v0/model/getModelsPipeline';

  var configHeader = {
    'userID': '965355806bf84442a8a168259ed8c06f',
    'ulcaApiKey': '4209d60edc-70e5-4b71-8427-c4665743e909'
  };

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
      showResponse: true,
    );
    return (response == null) ? null : LanguageModels.fromJson(response);
  }
}
