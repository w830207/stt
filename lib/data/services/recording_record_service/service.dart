import 'package:get/get.dart';
import 'package:stt/data/models/recording_record_model.dart';
import 'package:stt/data/services/recording_record_service/repository.dart';

class RecordingRecordsService extends GetxService {
  static RecordingRecordsService get to => Get.find();
  late final RecordingRecordsRepository storage;
  final RxList recordingRecordsList = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    storage = RecordingRecordsRepository();
    await storage.init();
    readRecords();
  }

  readRecords() {
    recordingRecordsList.value = storage.readRecordingRecords() ?? [];
  }

  writeRecords() {
    storage.writeRecordingRecords(recordingRecordsList);
  }

  addRecord(RecordModel record) {
    recordingRecordsList.add(record);
    writeRecords();
  }
}
