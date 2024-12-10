import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer?.cancel();
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Processing...',
        style: TextStyle(
            color: Color.fromARGB(255, 4, 40, 147),
            fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: 100.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 25.0,
              lineWidth: 4.0,
              percent: _progress,
              center: Text(
                "${(_progress * 100).toInt()}%",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              progressColor: const Color.fromARGB(255, 4, 40, 147),
            ),
            const SizedBox(height: 4),
            const Flexible(
              child: Text(
                'Please wait while we process your request.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle overflow if needed
                maxLines: 3, // Allow the text to wrap within 3 lines
              ),
            ),
          ],
        ),
      ),
    );
  }
}
