import 'package:get_storage/get_storage.dart';

class RecordingRecordsRepository {
  late final GetStorage storage;

  RecordingRecordsRepository() {
    storage = GetStorage('Recording');
  }

  init() async {
    await GetStorage.init();
  }

  dynamic readRecordingRecords() {
    return storage.read("RecordingRecord");
  }

  Future<void> writeRecordingRecords(dynamic value) async {
    await storage.write("RecordingRecord", value);
  }

  clear() async {
    await storage.erase();
  }
}
