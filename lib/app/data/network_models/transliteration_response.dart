class TransliterationResponse {
  List<Output>? output;
  String? config;
  String? taskType;

  TransliterationResponse({this.output, this.config, this.taskType});

  TransliterationResponse.fromJson(Map<String, dynamic> json) {
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