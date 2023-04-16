class ResponseModel {
  final String? text;
  final String? translate;
  final String? error;
  final double estimatedTime;

  ResponseModel(
    this.text,
    this.translate,
    this.error,
    this.estimatedTime,
  );

  ResponseModel.fromJson(dynamic json)
      : text = json['text'] ?? "",
        translate = json['translation_text'] ?? "",
        error = json['error'] ?? "",
        estimatedTime = json['estimated_time'] ?? 0.0;

  Map<String, dynamic> toJson() => {
        'text': text,
        'translation_text': translate,
        'error': error,
        'estimated_time': estimatedTime,
      };
}
