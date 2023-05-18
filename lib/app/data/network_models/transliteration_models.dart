class TransliterationModels {
  String? message;
  List<Data>? data;
  int? count;

  TransliterationModels({this.message, this.data, this.count});

  TransliterationModels.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class Data {
  String? name;
  String? version;
  String? description;
  String? refUrl;
  Task? task;
  List<Languages>? languages;
  String? license;
  String? licenseUrl;
  List<String>? domain;
  Submitter? submitter;
  InferenceEndPoint? inferenceEndPoint;
  TrainingDataset? trainingDataset;
  String? modelId;
  String? userId;
  int? submittedOn;
  int? publishedOn;
  String? status;
  String? unpublishReason;

  Data(
      {this.name,
      this.version,
      this.description,
      this.refUrl,
      this.task,
      this.languages,
      this.license,
      this.licenseUrl,
      this.domain,
      this.submitter,
      this.inferenceEndPoint,
      this.trainingDataset,
      this.modelId,
      this.userId,
      this.submittedOn,
      this.publishedOn,
      this.status,
      this.unpublishReason});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
    description = json['description'];
    refUrl = json['refUrl'];
    task = json['task'] != null ? Task.fromJson(json['task']) : null;
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    license = json['license'];
    licenseUrl = json['licenseUrl'];
    domain = json['domain'].cast<String>();
    submitter = json['submitter'] != null
        ? Submitter.fromJson(json['submitter'])
        : null;
    inferenceEndPoint = json['inferenceEndPoint'] != null
        ? InferenceEndPoint.fromJson(json['inferenceEndPoint'])
        : null;
    trainingDataset = json['trainingDataset'] != null
        ? TrainingDataset.fromJson(json['trainingDataset'])
        : null;
    modelId = json['modelId'];
    userId = json['userId'];
    submittedOn = json['submittedOn'];
    publishedOn = json['publishedOn'];
    status = json['status'];
    unpublishReason = json['unpublishReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['version'] = version;
    data['description'] = description;
    data['refUrl'] = refUrl;
    if (task != null) {
      data['task'] = task!.toJson();
    }
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    data['license'] = license;
    data['licenseUrl'] = licenseUrl;
    data['domain'] = domain;
    if (submitter != null) {
      data['submitter'] = submitter!.toJson();
    }
    if (inferenceEndPoint != null) {
      data['inferenceEndPoint'] = inferenceEndPoint!.toJson();
    }
    if (trainingDataset != null) {
      data['trainingDataset'] = trainingDataset!.toJson();
    }
    data['modelId'] = modelId;
    data['userId'] = userId;
    data['submittedOn'] = submittedOn;
    data['publishedOn'] = publishedOn;
    data['status'] = status;
    data['unpublishReason'] = unpublishReason;
    return data;
  }
}

class Task {
  String? type;

  Task({this.type});

  Task.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}

class Languages {
  String? sourceLanguageName;
  String? sourceLanguage;
  String? sourceScriptCode;
  String? targetLanguageName;
  String? targetLanguage;
  String? targetScriptCode;

  Languages(
      {this.sourceLanguageName,
      this.sourceLanguage,
      this.sourceScriptCode,
      this.targetLanguageName,
      this.targetLanguage,
      this.targetScriptCode});

  Languages.fromJson(Map<String, dynamic> json) {
    sourceLanguageName = json['sourceLanguageName'];
    sourceLanguage = json['sourceLanguage'];
    sourceScriptCode = json['sourceScriptCode'];
    targetLanguageName = json['targetLanguageName'];
    targetLanguage = json['targetLanguage'];
    targetScriptCode = json['targetScriptCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceLanguageName'] = sourceLanguageName;
    data['sourceLanguage'] = sourceLanguage;
    data['sourceScriptCode'] = sourceScriptCode;
    data['targetLanguageName'] = targetLanguageName;
    data['targetLanguage'] = targetLanguage;
    data['targetScriptCode'] = targetScriptCode;
    return data;
  }
}

class Submitter {
  String? name;
  String? oauthId;
  String? aboutMe;
  List<Team>? team;

  Submitter({this.name, this.oauthId, this.aboutMe, this.team});

  Submitter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oauthId = json['oauthId'];
    aboutMe = json['aboutMe'];
    if (json['team'] != null) {
      team = <Team>[];
      json['team'].forEach((v) {
        team!.add(Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['oauthId'] = oauthId;
    data['aboutMe'] = aboutMe;
    if (team != null) {
      data['team'] = team!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Team {
  String? name;
  String? oauthId;
  String? aboutMe;

  Team({this.name, this.oauthId, this.aboutMe});

  Team.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oauthId = json['oauthId'];
    aboutMe = json['aboutMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['oauthId'] = oauthId;
    data['aboutMe'] = aboutMe;
    return data;
  }
}

class InferenceEndPoint {
  Schema? schema;
  bool? isSyncApi;
  String? asyncApiDetails;

  InferenceEndPoint({this.schema, this.isSyncApi, this.asyncApiDetails});

  InferenceEndPoint.fromJson(Map<String, dynamic> json) {
    schema = json['schema'] != null ? Schema.fromJson(json['schema']) : null;
    isSyncApi = json['isSyncApi'];
    asyncApiDetails = json['asyncApiDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (schema != null) {
      data['schema'] = schema!.toJson();
    }
    data['isSyncApi'] = isSyncApi;
    data['asyncApiDetails'] = asyncApiDetails;
    return data;
  }
}

class Schema {
  String? taskType;
  Request? request;
  ModelResponse? response;

  Schema({this.taskType, this.request, this.response});

  Schema.fromJson(Map<String, dynamic> json) {
    taskType = json['taskType'];
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    response =
        json['response'] != null ? ModelResponse.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskType'] = taskType;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Request {
  List<Input>? input;
  Config? config;

  Request({this.input, this.config});

  Request.fromJson(Map<String, dynamic> json) {
    if (json['input'] != null) {
      input = <Input>[];
      json['input'].forEach((v) {
        input!.add(Input.fromJson(v));
      });
    }
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (input != null) {
      data['input'] = input!.map((v) => v.toJson()).toList();
    }
    if (config != null) {
      data['config'] = config!.toJson();
    }
    return data;
  }
}

class Input {
  String? source;
  String? target;

  Input({this.source, this.target});

  Input.fromJson(Map<String, dynamic> json) {
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

class Config {
  String? modelId;
  int? numSuggestions;
  bool? isSentence;
  Languages? language;

  Config({this.modelId, this.numSuggestions, this.isSentence, this.language});

  Config.fromJson(Map<String, dynamic> json) {
    modelId = json['modelId'];
    numSuggestions = json['numSuggestions'];
    isSentence = json['isSentence'];
    language =
        json['language'] != null ? Languages.fromJson(json['language']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modelId'] = modelId;
    data['numSuggestions'] = numSuggestions;
    data['isSentence'] = isSentence;
    if (language != null) {
      data['language'] = language!.toJson();
    }
    return data;
  }
}

class ModelResponse {
  List<Output>? output;
  String? config;
  String? taskType;

  ModelResponse({this.output, this.config, this.taskType});

  ModelResponse.fromJson(Map<String, dynamic> json) {
    if (json['output'] != null) {
      output = <Output>[];
      json['output'].forEach((v) {
        output!.add(Output.fromJson(v));
      });
    }
    config = json['config'];
    taskType = json['taskType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (output != null) {
      data['output'] = output!.map((v) => v.toJson()).toList();
    }
    data['config'] = config;
    data['taskType'] = taskType;
    return data;
  }
}

class Output {
  String? source;
  List<String>? target;

  Output({this.source, this.target});

  Output.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    target = json['target'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['target'] = target;
    return data;
  }
}

class TrainingDataset {
  String? datasetId;
  String? description;

  TrainingDataset({this.datasetId, this.description});

  TrainingDataset.fromJson(Map<String, dynamic> json) {
    datasetId = json['datasetId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datasetId'] = datasetId;
    data['description'] = description;
    return data;
  }
}
