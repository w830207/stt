import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future stop() async {
  await EasyLoading.dismiss();
}

Future recording(RecorderController recorderController) async {
  EasyLoading.instance
    ..maskColor = Colors.black12
    ..indicatorWidget = AudioWaveforms(
      enableGesture: true,
      size: Size(0.5.sw, 70),
      recorderController: recorderController,
      waveStyle: const WaveStyle(
        waveColor: Colors.white,
        extendWaveform: true,
        showMiddleLine: false,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xFF1E1B26),
      ),
      padding: const EdgeInsets.only(left: 18),
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
}
