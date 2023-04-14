import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class WaveBubble extends StatefulWidget {
  final String path;
  final double width;

  const WaveBubble({
    Key? key,
    required this.width,
    required this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    // spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  void _preparePlayer() async {
    controller = PlayerController();
    controller.preparePlayer(path: widget.path);
    controller.extractWaveformData(
      path: widget.path,
      noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width),
    );
    // .then((waveformData) => debugPrint(waveformData.toString()));

    playerStateSubscription = controller.onPlayerStateChanged.listen((state) {
      if (state.isStopped) _preparePlayer();
      setState(() {});
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF343145),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              controller.playerState.isPlaying
                  ? await controller.pausePlayer()
                  : await controller.startPlayer();
            },
            icon: Icon(
              controller.playerState.isPlaying ? Icons.stop : Icons.play_arrow,
            ),
            color: Colors.white,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          AudioFileWaveforms(
            size: Size(widget.width, 70),
            playerController: controller,
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: playerWaveStyle,
          ),
        ],
      ),
    );
  }
}
