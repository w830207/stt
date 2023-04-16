// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stt/common/theme.dart';

Future stop() async {
  await EasyLoading.dismiss();
}

bool isLoading() {
  return EasyLoading.isShow;
}

Future loading() async {
  EasyLoading.instance.indicatorWidget = SizedBox(
    width: 50,
    child: Column(
      children: const [
        SpinKitFadingCircle(
          color: Colors.white,
        ),
        Text(
          "loading",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
  await EasyLoading.show();
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
        color: Colors.black12,
      ),
      padding: const EdgeInsets.only(left: 18),
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
}
