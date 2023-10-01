import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happy_button/native_api/local_notification.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/cupertino.dart';

const List<String> _timerList = <String>[
  '10초',
  '30초',
  '1분',
  '2분',
  '3분',
  '5분',
  '10분',
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
  late num id = widget.id;
  late String name = widget.name;
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false; // 재생 상태 변수

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

  String _selectedTime = '10초'; // 기본값 설정
  Future<void> _openTimePickerDialog() async {
    final selectedTime = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('시간 선택'),
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
                      time,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return true;
        },
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150.0),
              GestureDetector(
                onTap: () async {
                  playMusic();
                },
                child: Hero(
                  tag: widget.imagePath, // 이전 화면과 동일한 Hero 태그 사용
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 300.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정
                    ),
                    child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Column(
                children: [
                  AnimatedButton(
                    width: 180,
                    height: 80,
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
                        const Text(
                          '재생하기',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AnimatedButton(
                    width: 180,
                    height: 80,
                    duration: 100,
                    color: Colors.amber.shade300,
                    onPressed: () {
                      // LocalNotification.timerNotification('sound${id + 1}', 5);
                      _openTimePickerDialog();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.alarm, size: 55),
                        Text(
                          '소리폭탄',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
