import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stt/common/theme.dart';

class FloatingButton extends StatefulWidget {
  final GestureLongPressStartCallback? micOnLongPressStart;
  final GestureLongPressEndCallback? micOnLongPressEnd;
  final VoidCallback? fileOnPressed;

  const FloatingButton({
    Key? key,
    this.micOnLongPressStart,
    this.micOnLongPressEnd,
    this.fileOnPressed,
  }) : super(key: key);

  @override
  FloatingButtonState createState() => FloatingButtonState();
}

class FloatingButtonState extends State<FloatingButton> {
  final flipController = FlipCardController();
  RotateSide rotateSide = RotateSide.right;

  void flip(DragStartDetails detail) {
    if (detail.globalPosition.dx - 0.5.sw > 0) {
      rotateSide = RotateSide.right;
    } else {
      rotateSide = RotateSide.left;
    }

    flipController.flipcard();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: flipController,
      rotateSide: rotateSide,
      onTapFlipping: false,
      axis: FlipAxis.vertical,
      animationDuration: const Duration(milliseconds: 600),
      frontWidget: GestureDetector(
        onLongPressStart: widget.micOnLongPressStart,
        onLongPressEnd: widget.micOnLongPressEnd,
        onHorizontalDragStart: flip,
        child: FloatingActionButton(
          backgroundColor: AppTheme.orange,
          onPressed: () {},
          child: const Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
      backWidget: GestureDetector(
        onHorizontalDragStart: flip,
        child: FloatingActionButton(
          backgroundColor: AppTheme.orange,
          onPressed: widget.fileOnPressed,
          child: const Icon(
            Icons.file_open_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
