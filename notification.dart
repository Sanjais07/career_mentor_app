import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Optional: for sound effects

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  final _breakController = TextEditingController();
  bool _isBreakOver = false;
  int _secondsRemaining = 0;
  int _totalBreakTime = 0;
  Timer? _countdownTimer;
  Timer? _blinkTimer;
  Color _backgroundColor = Colors.white;
  List<String> _quotes = [
    "Take a deep breath. Relax your mind.",
    "Stretch your legs a bit.",
    "Stay hydrated!",
    "You're doing great!",
    "Keep calm and carry on."
  ];
  int _quoteIndex = 0;

  // final player = AudioPlayer(); // Optional: for playing sound

  void _startBreakTimer() {
    final seconds = int.tryParse(_breakController.text);
    if (seconds != null && seconds > 0) {
      setState(() {
        _isBreakOver = false;
        _backgroundColor = Colors.white;
        _secondsRemaining = seconds;
        _totalBreakTime = seconds;
        _quoteIndex = 0;
      });

      _startCountdownTimer(seconds);
    }
  }

  void _startCountdownTimer(int seconds) {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          _quoteIndex = (_quoteIndex + 1) % _quotes.length;
        });
      } else {
        timer.cancel();
        _onBreakOver();
      }
    });
  }

  void _onBreakOver() {
    setState(() {
      _isBreakOver = true;
    });
    _startBlinkingEffect();

    // Optional: Play sound
    // player.play(AssetSource('alarm.mp3'));
  }

  void _startBlinkingEffect() {
    bool toggle = false;
    _blinkTimer?.cancel();
    _blinkTimer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        _backgroundColor = toggle ? Colors.redAccent : Colors.white;
        toggle = !toggle;
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _blinkTimer?.cancel();
    _breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalBreakTime > 0
        ? (1 - (_secondsRemaining / _totalBreakTime))
        : 0;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: Text("Reminder & Break Timer")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isBreakOver
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.alarm, size: 60, color: Colors.black),
                    SizedBox(height: 20),
                    Text(
                      "BREAK TIME IS OVER\nTIME TO STUDY!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isBreakOver = false;
                          _backgroundColor = Colors.white;
                          _secondsRemaining = 0;
                        });
                        _blinkTimer?.cancel();
                      },
                      icon: Icon(Icons.refresh),
                      label: Text("Reset"),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Set Break Time (in seconds)",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _breakController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter seconds",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startBreakTimer,
                    child: Text("Start Break"),
                  ),
                  SizedBox(height: 30),
                  if (_secondsRemaining > 0)
                    Column(
                      children: [
                        Text(
                          "Time Remaining: $_secondsRemaining s",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                              ),
                            ),
                            Text(
                              "${_secondsRemaining}s",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 600),
                          child: Text(
                            _quotes[_quoteIndex],
                            key: ValueKey<String>(_quotes[_quoteIndex]),
                            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
