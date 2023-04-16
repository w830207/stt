enum RecordModelType {
  recording,
  file,
}

extension Computed on RecordModelType {
  String toValueString() {
    return toString().split('.').last;
  }
}

class RecordModel {
  String path;
  String createdTime;
  String type;

  RecordModel({
    this.path = "",
    required this.createdTime,
    required this.type,
  });

  RecordModel.fromJson(Map<dynamic, dynamic> json)
      : path = json['path'],
        createdTime = json['createdTime'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'path': path,
        'createdTime': createdTime,
        'type': type,
      };
}
