import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_app/repository.dart';

import 'widgets.dart';

const timerKey = "timer";

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  Timer? _blinkTimer;
  int _seconds = 0;
  bool _play = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
    _startTimer();
  }

  void startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _play = false;
    setState(() {});
    startBlinking();
  }

  void _loadSavedTime() async {
    int? savedSeconds = SharedPreferenceRepository.instance.getValue(timerKey);
    if (savedSeconds != null) {
      setState(() {
        _seconds = savedSeconds;
      });
    }
  }

  void _saveTime() async {
    SharedPreferenceRepository.instance.setKeyValue(timerKey, _seconds);
    _timer?.cancel();
    _play = true;
    setState(() {});
  }

  void _clear() async {
    var empty = SharedPreferenceRepository.instance.empty();
    _timer?.cancel();
    _play = true;
    _seconds = 0;
    setState(() {});
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int remainingSeconds = totalSeconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr : $minStr : $secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.3, 1.0],
                  colors: [Colors.amberAccent, Colors.white])),
          child: Column(
            children: [
              const Text(
                "Timer",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_isVisible) ? Colors.amber : Colors.amber[300]!),
                child: Center(
                    child: Text(
                  _formatTime(_seconds),
                  style: const TextStyle(fontSize: 30),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundButton(
                    onPressed: () {
                      _clear();
                      setState(() {});
                    },
                    color: Colors.amber,
                    size: 70,
                    icon: Icons.close,
                  ),
                  RoundButton(
                      size: 70,
                      color: Colors.amber[800]!,
                      onPressed: () {
                        (!_play) ? _saveTime() : _startTimer();
                      },
                      icon: (!_play) ? Icons.pause : Icons.play_arrow)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
