import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happy_button/native_api/local_notification.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<int> _timerList = <int>[
  10,
  30,
  60,
  120,
  180,
  300,
  600,
];

class DetailScreen extends StatefulWidget {
  final String imagePath, name;
  final num id;

  const DetailScreen(
      {super.key,
      required this.imagePath,
      required this.id,
      required this.name});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int id = widget.id.toInt();
  late String name = widget.name;
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false; // 재생 상태 변수
  bool _isSetTimer = false;

  late Timer _timer;

  late int _selectedTime; // 기본값 설정

  @override
  void initState() {
    super.initState();
    // audioPlayer = AudioPlayer();
    LocalNotification.initialize();

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void _updateTimer(Timer timer) {
    if (_selectedTime == 0) {
      setState(() {
        _isSetTimer = false;
      });
      timer.cancel();
    } else {
      setState(() {
        _selectedTime = _selectedTime - 1;
      });
    }
  }

  void onStartPressed() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _updateTimer,
    );
  }

  void playMusic() async {
    String audioPath = 'sounds/sound${id + 1}.mp3';

    await audioPlayer.setSource(AssetSource(audioPath));
    await audioPlayer.setVolume(1);
    await audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  void stopMusic() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _openTimePickerDialog() async {
    final selectedTime = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '알림볼륨을 확인해주세요!',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: _timerList.map((time) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(time);
                    },
                    child: Text(
                      '$time초',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    // 사용자가 시간을 선택한 경우, 선택한 값을 업데이트
    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
        _isSetTimer = true;
      });
      LocalNotification.timerNotification('sound${id + 1}', selectedTime, id);
      onStartPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.amber.shade300,
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await audioPlayer.dispose();
          _timer.cancel();
          return true;
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  height:
                      _isSetTimer ? screenHeight * 0.05 : screenHeight * 0.1),
              if (_isSetTimer)
                Text(
                  '$_selectedTime초 후에 소리폭탄이 터집니다!!',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              SizedBox(height: screenHeight * 0.04),
              GestureDetector(
                onTap: () async {
                  playMusic();
                },
                child: Hero(
                  tag: widget.imagePath, // 이전 화면과 동일한 Hero 태그 사용
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정
                    ),
                    child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Column(
                children: [
                  AnimatedButton(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.1,
                    duration: 100,
                    color: Colors.amber.shade300,
                    onPressed: () {
                      _isPlaying ? stopMusic() : playMusic();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _isPlaying
                            ? const Icon(Icons.pause_circle, size: 55)
                            : const Icon(
                                Icons.play_circle,
                                size: 55,
                              ),
                        Text(
                          '재생하기',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AnimatedButton(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.1,
                    duration: 100,
                    color: Colors.amber.shade300,
                    onPressed: () {
                      if (_isSetTimer) {
                        LocalNotification.cancelNotification(id);
                        setState(() {
                          _isSetTimer = false;
                        });
                      } else {
                        _openTimePickerDialog();
                      }
                    },
                    child: _isSetTimer
                        ? Text(
                            '취소하기',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.alarm, size: 55),
                              Text(
                                '소리폭탄',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
