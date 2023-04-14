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
    recordingRecordsList.value = storage.readRecordingRecords() ?? [];
  }

  _writeRecords() {
    storage.writeRecordingRecords(recordingRecordsList);
  }

  addRecord(RecordingRecordModel record) {
    recordingRecordsList.add(record);
    _writeRecords();
  }
}
