import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stt/common/utils/get_file_name.dart';

import '../common/theme.dart';
import '../data/models/recording_record_model.dart';
import '../data/models/response_model.dart';

class SpeechToTextBox extends StatefulWidget {
  const SpeechToTextBox({
    Key? key,
    required this.record,
    required this.computeOnPressed,
    required this.deleteOnPressed,
    required this.chineseToEnglish,
    required this.englishToChinese,
  }) : super(key: key);

  final RecordModel record;
  final Future<ResponseModel> Function(String path) computeOnPressed;
  final Function(RecordModel record) deleteOnPressed;
  final Future<ResponseModel> Function(String text) chineseToEnglish;
  final Future<ResponseModel> Function(String text) englishToChinese;

  @override
  State<SpeechToTextBox> createState() => _SpeechToTextBoxState();
}

class _SpeechToTextBoxState extends State<SpeechToTextBox> {
  String answer = "answer";
  double width = 1.sw - 48.r;
  double height = 296.r;
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.black12,
    liveWaveColor: AppTheme.orange,
    seekLineColor: AppTheme.orange,
    spacing: 2.62,
    waveThickness: 2.6,
  );

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    controller = PlayerController();
    await controller.preparePlayer(path: widget.record.path);
    await controller.extractWaveformData(
      path: widget.record.path,
      noOfSamples: playerWaveStyle.getSamplesForWidth(width),
    );
    // .then((waveformData) => debugPrint(waveformData.toString()));

    playerStateSubscription =
        controller.onPlayerStateChanged.listen((state) async {
      if (state.isStopped) await _preparePlayer();
      setState(() {});
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  _speechToText() async {
    final response = await widget.computeOnPressed(widget.record.path);
    if (response.text!.isNotEmpty) {
      answer = response.text!;
      setState(() {});
    }
  }

  _translate(Object value) async {
    late final ResponseModel response;
    switch (value) {
      case 1:
        response = await widget.englishToChinese(answer);
        break;
      case -1:
        response = await widget.chineseToEnglish(answer);
        break;
    }
    answer = response.translate ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: AppTheme.decoration,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 22.r,
            left: 80.r,
            child: SizedBox(
              width: 242.r,
              child: Wrap(
                direction: Axis.vertical,
                spacing: 2.r,
                children: [
                  Text(
                    getFileName(widget.record.path),
                    style: AppTheme.fileName,
                  ),
                  Text(
                    widget.record.createdTime.toString(),
                    style: AppTheme.createdTime,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20.r,
            left: 20.r,
            child: Container(
              width: 40.r,
              height: 40.r,
              margin: EdgeInsets.only(right: 26.r),
              decoration: const BoxDecoration(
                color: AppTheme.blueGrey,
                shape: BoxShape.circle,
                boxShadow: [AppTheme.shadow],
              ),
              child: IconButton(
                onPressed: () async {
                  controller.playerState.isPlaying
                      ? await controller.pausePlayer()
                      : await controller.startPlayer();
                },
                icon: Icon(
                  controller.playerState.isPlaying
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
                color: Colors.black,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 66,
            left: 1.r,
            child: AudioFileWaveforms(
              size: Size(width, 70.r),
              playerController: controller,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: playerWaveStyle,
              continuousWaveform: false,
            ),
          ),
          Positioned(
            top: 152.r,
            left: 20.r,
            child: Container(
              width: 40.r,
              height: 40.r,
              margin: EdgeInsets.only(right: 26.r),
              decoration: const BoxDecoration(
                color: AppTheme.blueGrey,
                shape: BoxShape.circle,
                boxShadow: [AppTheme.shadow],
              ),
              child: IconButton(
                onPressed: _speechToText,
                icon: const Icon(Icons.textsms_outlined),
                color: Colors.black,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 198.r,
            left: 20.r,
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("ENG to CN "),
                  ),
                  const PopupMenuItem(
                    value: -1,
                    child: Text("CN to ENG "),
                  ),
                ];
              },
              onSelected: _translate,
              child: Container(
                width: 40.r,
                height: 40.r,
                margin: EdgeInsets.only(right: 26.r),
                decoration: const BoxDecoration(
                  color: AppTheme.blueGrey,
                  shape: BoxShape.circle,
                  boxShadow: [AppTheme.shadow],
                ),
                child: const Icon(
                  Icons.translate,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 244.r,
            left: 20.r,
            child: Container(
              width: 40.r,
              height: 40.r,
              margin: EdgeInsets.only(right: 26.r),
              decoration: const BoxDecoration(
                color: AppTheme.pink,
                shape: BoxShape.circle,
                boxShadow: [AppTheme.shadow],
              ),
              child: IconButton(
                onPressed: () {
                  widget.deleteOnPressed(widget.record);
                },
                icon: const Icon(Icons.delete),
                color: AppTheme.red,
              ),
            ),
          ),
          Positioned(
            top: 146.r,
            left: 80.r,
            child: Container(
              width: 242.r,
              height: 144.r,
              decoration: AppTheme.decoration.copyWith(
                color: AppTheme.blueGrey,
                boxShadow: null,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(answer),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
