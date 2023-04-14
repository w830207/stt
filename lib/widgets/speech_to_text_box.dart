import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models/recording_record_model.dart';
import '../data/models/response_model.dart';
import 'wave_player.dart';

class SpeechToTextBox extends StatefulWidget {
  const SpeechToTextBox({
    Key? key,
    required this.width,
    required this.height,
    required this.record,
    required this.computeOnPressed,
  }) : super(key: key);

  final double width;
  final double height;
  final RecordingRecordModel record;
  final Future<ResponseModel> Function(String path) computeOnPressed;

  @override
  State<SpeechToTextBox> createState() => _SpeechToTextBoxState();
}

class _SpeechToTextBoxState extends State<SpeechToTextBox> {
  String answer = "answer";

  _onPressed() async {
    final res = await widget.computeOnPressed(widget.record.path);
    if (res.text!.isNotEmpty) {
      answer = res.text!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black26,
      child: Column(
        children: [
          Text(widget.record.path),
          Text(widget.record.createdTime.toString()),
          WavePlayer(
            width: 200,
            path: widget.record.path,
          ),
          TextButton(
            onPressed: _onPressed,
            child: const Text("Compute"),
          ),
          Text(answer),
        ],
      ),
    );
  }
}
