import 'package:flutter/material.dart';
import 'package:stt/common/theme.dart';

class FloatingButton extends StatefulWidget {
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;
  final VoidCallback? onPressed;

  const FloatingButton({
    Key? key,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onPressed,
  }) : super(key: key);

  @override
  FloatingButtonState createState() => FloatingButtonState();
}

class FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: widget.onLongPressStart,
      onLongPressEnd: widget.onLongPressEnd,
      onTap: widget.onPressed,
      child: FloatingActionButton(
        backgroundColor: AppTheme.orange,
        onPressed: () {},
        child: const Icon(
          Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
