class ResponseModel {
  final String? text;
  final String? error;
  final double estimatedTime;

  ResponseModel(
    this.text,
    this.error,
    this.estimatedTime,
  );

  ResponseModel.fromJson(dynamic json)
      : text = json['text'] ?? "",
        error = json['error'] ?? "",
        estimatedTime = json['estimated_time'] ?? 0.0;

  Map<String, dynamic> toJson() => {
        'text': text,
        'error': error,
        'estimated_time': estimatedTime,
      };
}
