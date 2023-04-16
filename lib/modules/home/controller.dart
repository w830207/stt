import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stt/common/popup.dart' as popup;
import 'package:stt/data/models/recording_record_model.dart';
import 'package:stt/data/models/response_model.dart';
import 'package:stt/data/services/api_service/service.dart';
import 'package:stt/data/services/recording_record_service/service.dart';

class HomeController extends GetxController {
  late final RecorderController recorderController;
  late Directory appDirectory;
  late final RxList recordingRecordsList;
  DateTime tempTime = DateTime(2011, 11, 11, 11, 11);
  RxString title = "".obs;

  Future<void> onFetchMore() async {}

  Future<void> onReFetch() async {}

  @override
  void onInit() {
    super.onInit();
    getDir();
    initRecorderController();
    recordingRecordsList = RecordingRecordsService.to.recordingRecordsList;
    title.value = ApiService.to.huggingFaceModel;
  }

  selectModel(Object modelName) {
    title.value = modelName as String;
    ApiService.to.changeModel(modelName);
  }

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }

  void initRecorderController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  Future<void> recordingOnStart(LongPressStartDetails details) async {
    popup.recording(recorderController);
    tempTime = DateTime.now().toLocal();
    String formattedTime =
        DateFormat("yMMddHHmmss").format(tempTime).toString();
    final path = "${appDirectory.path}/recording-$formattedTime.m4a";
    try {
      await recorderController.record(path: path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> recordingOnEnd(LongPressEndDetails details) async {
    recorderController.reset();
    popup.stop();
    final path = await recorderController.stop(false);
    if (path == null) return;

    final record = RecordModel.fromJson({
      'path': path,
      'createdTime': tempTime.toString(),
      'type': RecordModelType.recording.toValueString(),
    });
    RecordingRecordsService.to.addRecord(record);
  }

  Future<void> choseFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;

    File file = File(result.files.single.path!);
    tempTime = DateTime.now().toLocal();
    final record = RecordModel.fromJson({
      'path': file.path,
      'createdTime': tempTime.toString(),
      'type': RecordModelType.file.toValueString(),
    });
    RecordingRecordsService.to.addRecord(record);
  }

  Future<ResponseModel> speechToText(String path) async {
    return await ApiService.to.automaticSpeechRecognition(filePath: path);
  }

  void deleteRecord(RecordModel record) {
    recordingRecordsList.removeWhere((element) {
      if (element.runtimeType == RecordModel) {
        return record.path == element.path;
      }
      return record.path == element['path'];
    });
    RecordingRecordsService.to.writeRecords();
    if (record.type == RecordModelType.file.toValueString()) return;
    File(record.path).delete();
  }
}
