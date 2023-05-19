class TranslationResponse {
  List<PipelineResponse>? pipelineResponse;

  TranslationResponse({this.pipelineResponse});

  TranslationResponse.fromJson(Map<String, dynamic> json) {
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
  String? config;
  List<Output>? output;
  String? audio;

  PipelineResponse({this.taskType, this.config, this.output, this.audio});

  PipelineResponse.fromJson(Map<String, dynamic> json) {
    taskType = json['taskType'];
    config = json['config'];
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
    data['config'] = config;
    if (output != null) {
      data['output'] = output!.map((v) => v.toJson()).toList();
    }
    data['audio'] = audio;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['source'] = source;
    data['target'] = target;
    return data;
  }
}