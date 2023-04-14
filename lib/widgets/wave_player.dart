import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class WavePlayer extends StatefulWidget {
  final String path;
  final double width;

  const WavePlayer({
    Key? key,
    required this.width,
    required this.path,
  }) : super(key: key);

  @override
  State<WavePlayer> createState() => _WavePlayerState();
}

class _WavePlayerState extends State<WavePlayer> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    controller = PlayerController();
    await controller.preparePlayer(path: widget.path);
    await controller.extractWaveformData(
      path: widget.path,
      noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width),
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
            waveformType: WaveformType.long,
            playerWaveStyle: playerWaveStyle,
            continuousWaveform: false,
          ),
        ],
      ),
    );
  }
}
