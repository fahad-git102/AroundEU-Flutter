import 'package:flutter/material.dart';

class AudioRecordButton extends StatefulWidget {
  final Function() onRecordStart;
  final Function() onRecordCancel;
  final Function() onRecordComplete;
  final Function() onRecordLock;

  const AudioRecordButton({
    required this.onRecordStart,
    required this.onRecordCancel,
    required this.onRecordComplete,
    required this.onRecordLock,
  });

  @override
  State<AudioRecordButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioRecordButton> {
  bool isRecording = false;
  Offset buttonPosition = Offset(0, 0); // Tracks button position during drag
  Offset initialPosition = Offset(0, 0); // Initial position to compare with during drag
  bool isLocked = false;
  bool isCancelled = false;

  // Start recording when the button is tapped
  void _startRecording() {
    print('start recording');
    setState(() {
      isRecording = true;
      isLocked = false;
      isCancelled = false;
      buttonPosition = Offset(0, 0); // Reset position
      initialPosition = Offset(0, 0); // Reset initial position
    });
    widget.onRecordStart();
  }

  // Complete the recording
  void _completeRecording() {
    if (!isCancelled && !isLocked) {
      widget.onRecordComplete();
    }
    setState(() {
      isRecording = false;
      buttonPosition = Offset(0, 0); // Reset button position
    });
  }

  // Cancel the recording
  void _cancelRecording() {
    widget.onRecordCancel();
    setState(() {
      isCancelled = true;
      isRecording = false;
      buttonPosition = Offset(0, 0); // Reset button position
    });
  }

  // Lock the recording
  void _lockRecording() {
    widget.onRecordLock();
    setState(() {
      isLocked = true;
      isRecording = false;
      buttonPosition = Offset(0, 0); // Reset button position
    });
  }

  // Handle the drag events
  void _handleDragUpdate(DragUpdateDetails details) {
    if (isRecording && !isLocked) {
      setState(() {
        buttonPosition += details.delta;

        // Check for cancel condition (horizontal slide to the left)
        if (buttonPosition.dx < -100) {
          _cancelRecording();
        }

        // Check for lock condition (vertical slide upwards)
        if (buttonPosition.dy < -100) {
          _lockRecording();
        }
      });
    }
  }

  // Reset button when drag ends
  void _handleDragEnd(DragEndDetails details) {
    if (!isCancelled && !isLocked) {
      _completeRecording();
    }
    setState(() {
      buttonPosition = Offset(0, 0); // Reset button position
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startRecording,
      onPanUpdate: _handleDragUpdate,
      onPanEnd: _handleDragEnd,
      child: Transform.translate(
        offset: buttonPosition,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.blue, // Button color
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(0, 1),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
