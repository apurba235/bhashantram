class LanguageModels {
  List<Languages>? languages;
  List<PipelineResponseConfig>? pipelineResponseConfig;
  PipelineInferenceAPIEndPoint? pipelineInferenceAPIEndPoint;

  LanguageModels(
      {this.languages,
        this.pipelineResponseConfig,
        this.pipelineInferenceAPIEndPoint});

  LanguageModels.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    if (json['pipelineResponseConfig'] != null) {
      pipelineResponseConfig = <PipelineResponseConfig>[];
      json['pipelineResponseConfig'].forEach((v) {
        pipelineResponseConfig!.add(PipelineResponseConfig.fromJson(v));
      });
    }
    pipelineInferenceAPIEndPoint = json['pipelineInferenceAPIEndPoint'] != null
        ? PipelineInferenceAPIEndPoint.fromJson(
        json['pipelineInferenceAPIEndPoint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    if (pipelineResponseConfig != null) {
      data['pipelineResponseConfig'] =
          pipelineResponseConfig!.map((v) => v.toJson()).toList();
    }
    if (pipelineInferenceAPIEndPoint != null) {
      data['pipelineInferenceAPIEndPoint'] =
          pipelineInferenceAPIEndPoint!.toJson();
    }
    return data;
  }
}

class Languages {
  String? sourceLanguage;
  List<String>? targetLanguageList;

  Languages({this.sourceLanguage, this.targetLanguageList});

  Languages.fromJson(Map<String, dynamic> json) {
    sourceLanguage = json['sourceLanguage'];
    targetLanguageList = json['targetLanguageList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceLanguage'] = sourceLanguage;
    data['targetLanguageList'] = targetLanguageList;
    return data;
  }
}

class PipelineResponseConfig {
  String? taskType;
  List<Config>? config;

  PipelineResponseConfig({this.taskType, this.config});

  PipelineResponseConfig.fromJson(Map<String, dynamic> json) {
    taskType = json['taskType'];
    if (json['config'] != null) {
      config = <Config>[];
      json['config'].forEach((v) {
        config!.add(Config.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskType'] = taskType;
    if (config != null) {
      data['config'] = config!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Config {
  String? serviceId;
  String? modelId;
  Language? language;
  List<String>? domain;
  List<String>? supportedVoices;

  Config(
      {this.serviceId,
        this.modelId,
        this.language,
        this.domain,
        this.supportedVoices});

  Config.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    modelId = json['modelId'];
    language = json['language'] != null
        ? Language.fromJson(json['language'])
        : null;
    domain = json['domain'] !=null ? json['domain'].cast<String>() : [];
    supportedVoices = json['supportedVoices'] != null ? json['supportedVoices'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['serviceId'] = serviceId;
    data['modelId'] = modelId;
    if (language != null) {
      data['language'] = language!.toJson();
    }
    data['domain'] = domain;
    data['supportedVoices'] = supportedVoices;
    return data;
  }
}

class Language {
  String? sourceLanguage;
  String? targetLanguage;

  Language({this.sourceLanguage, this.targetLanguage});

  Language.fromJson(Map<String, dynamic> json) {
    sourceLanguage = json['sourceLanguage'];
    targetLanguage = json['targetLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceLanguage'] = sourceLanguage;
    data['targetLanguage'] = targetLanguage;
    return data;
  }
}

class PipelineInferenceAPIEndPoint {
  String? callbackUrl;
  InferenceApiKey? inferenceApiKey;
  bool? isMultilingualEnabled;
  bool? isSyncApi;

  PipelineInferenceAPIEndPoint(
      {this.callbackUrl,
        this.inferenceApiKey,
        this.isMultilingualEnabled,
        this.isSyncApi});

  PipelineInferenceAPIEndPoint.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
    inferenceApiKey = json['inferenceApiKey'] != null
        ? InferenceApiKey.fromJson(json['inferenceApiKey'])
        : null;
    isMultilingualEnabled = json['isMultilingualEnabled'];
    isSyncApi = json['isSyncApi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callbackUrl'] = callbackUrl;
    if (inferenceApiKey != null) {
      data['inferenceApiKey'] = inferenceApiKey!.toJson();
    }
    data['isMultilingualEnabled'] = isMultilingualEnabled;
    data['isSyncApi'] = isSyncApi;
    return data;
  }
}

class InferenceApiKey {
  String? name;
  String? value;

  InferenceApiKey({this.name, this.value});

  InferenceApiKey.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}