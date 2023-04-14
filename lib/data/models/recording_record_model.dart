class RecordingRecordModel {
  String path;
  late String createdTime;

  RecordingRecordModel({
    this.path = "",
    required this.createdTime,
  });

  RecordingRecordModel.fromJson(Map<dynamic, dynamic> json)
      : path = json['path'],
        createdTime = json['createdTime'];

  Map<String, dynamic> toJson() => {
        'path': path,
        'createdTime': createdTime,
      };
}
