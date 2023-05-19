class AsrTranslationResponse {
  List<PipelineResponse>? pipelineResponse;

  AsrTranslationResponse({this.pipelineResponse});

  AsrTranslationResponse.fromJson(Map<String, dynamic> json) {
    if (json['pipelineResponse'] != null) {
      pipelineResponse = <PipelineResponse>[];
      json['pipelineResponse'].forEach((v) {
        pipelineResponse!.add(PipelineResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pipelineResponse != null) {
      data['pipelineResponse'] =
          pipelineResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PipelineResponse {
  String? taskType;
  Config? config;
  List<Output>? output;
  String? audio;

  PipelineResponse({this.taskType, this.config, this.output, this.audio});

  PipelineResponse.fromJson(Map<String, dynamic> json) {
    taskType = json['taskType'];
    config =
    json['config'] != null ? Config.fromJson(json['config']) : null;
    if (json['output'] != null) {
      output = <Output>[];
      json['output'].forEach((v) {
        output!.add(Output.fromJson(v));
      });
    }
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskType'] = taskType;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    if (output != null) {
      data['output'] = output!.map((v) => v.toJson()).toList();
    }
    data['audio'] = audio;
    return data;
  }
}

class Config {
  String? serviceId;
  Language? language;
  String? audioFormat;
  String? encoding;
  int? samplingRate;
  String? postProcessors;

  Config(
      {this.serviceId,
        this.language,
        this.audioFormat,
        this.encoding,
        this.samplingRate,
        this.postProcessors});

  Config.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    language = json['language'] != null
        ? Language.fromJson(json['language'])
        : null;
    audioFormat = json['audioFormat'];
    encoding = json['encoding'];
    samplingRate = json['samplingRate'];
    postProcessors = json['postProcessors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceId'] = serviceId;
    if (language != null) {
      data['language'] = language!.toJson();
    }
    data['audioFormat'] = audioFormat;
    data['encoding'] = encoding;
    data['samplingRate'] = samplingRate;
    data['postProcessors'] = postProcessors;
    return data;
  }
}

class Language {
  String? sourceLanguage;
  String? sourceScriptCode;

  Language({this.sourceLanguage, this.sourceScriptCode});

  Language.fromJson(Map<String, dynamic> json) {
    sourceLanguage = json['sourceLanguage'];
    sourceScriptCode = json['sourceScriptCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceLanguage'] = sourceLanguage;
    data['sourceScriptCode'] = sourceScriptCode;
    return data;
  }
}

class Output {
  String? source;
  String? target;

  Output({this.source, this.target});

  Output.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['target'] = target;
    return data;
  }
}