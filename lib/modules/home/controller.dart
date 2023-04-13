import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stt/common/popup.dart' as popup;

class HomeController extends GetxController {
  RxList list = [].obs;
  late final RecorderController recorderController;
  late String path;
  late Directory appDirectory;

  Future<void> onFetchMore() async {}

  Future<void> onReFetch() async {}

  @override
  void onInit() {
    super.onInit();
    getDir();
    initRecorderController();
  }

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
  }

  void initRecorderController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void recordingOnStart(LongPressStartDetails details) {
    popup.recording(recorderController);
    var now = DateTime.now();
    DateFormat("y-M-d-H-m-s").format(now);

    try {
      recorderController.record(path: path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void recordingOnEnd(LongPressEndDetails details) {
    recorderController.reset();
    popup.stop();
    recorderController.stop(false);
  }
}
