import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happy_button/native_api/local_notification.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_button/provider/counter_provider.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        //MyID
        'android': 'ca-app-pub-8647279125417942/8332979726',
      }
    : {
        //testID
        'android': 'ca-app-pub-3940256099942544/5224354917',
      };

const List<int> _timerList = <int>[
  10,
  30,
  60,
  120,
  180,
  300,
  600,
];

class DetailScreen extends ConsumerStatefulWidget {
  final String imagePath, name;
  final num id;

  const DetailScreen(
      {super.key,
      required this.imagePath,
      required this.id,
      required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailScreenState();

  // @override
  // State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late int id = widget.id.toInt();
  late String name = widget.name;
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false; // 재생 상태 변수
  bool _isSetTimer = false;

  late Timer _timer;

  late int _selectedTime = 0; // 소리폭탄 설정 초
  late SharedPreferences sharedAlarmData; //알람시간 저장
  late DateTime alarmTime; // 소리폭탄 설정 시각(type:dateTime)
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

    loadAlarmTime();
  }

  @override
  void dispose() async {
    if (_isSetTimer) _timer.cancel();
    super.dispose();
  }

  void loadAlarmTime() async {
    sharedAlarmData = await SharedPreferences.getInstance();
    final int savedAlarmTimeMilliseconds = sharedAlarmData.getInt(name) ?? 0;
    alarmTime = DateTime.fromMillisecondsSinceEpoch(savedAlarmTimeMilliseconds);

    // 알람 시간이 현재 시간 이전이라면 타이머를 시작합니다.
    // print(alarmTime);

    _selectedTime = alarmTime.difference(DateTime.now()).inSeconds;
    print(_selectedTime);
    if (_selectedTime > 0) {
      setState(() {
        _isSetTimer = true;
      });
      onStartPressed();
    }
  }

  void onStartPressed() {
    _selectedTime = alarmTime.difference(DateTime.now()).inSeconds + 1;

    // _selectedTime = 10;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _updateTimer,
    );
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
            '알림볼륨이 켜져야\n소리폭탄이 터집니다!',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: _timerList.map((time) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
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
        _isSetTimer = true;
      });
      LocalNotification.timerNotification('sound${id + 1}', selectedTime, id);
      final DateTime currentTime = DateTime.now();
      alarmTime = currentTime.add(Duration(seconds: selectedTime));
      sharedAlarmData = await SharedPreferences.getInstance();
      sharedAlarmData.setInt(name, alarmTime.millisecondsSinceEpoch);
      onStartPressed();
    }
  }

  RewardedAd? _rewardedAd;
  void loadAd() {
    RewardedAd.load(
        adUnitId: UNIT_ID['android']!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  final bool _isRewardedAdReady = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);

    print('count$count');
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
          if (_isSetTimer) _timer.cancel();
          return true;
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              if (_isSetTimer)
                Container(
                  width: 120,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AnimatedFlipCounter(
                      duration: const Duration(milliseconds: 500),
                      value: _selectedTime,
                      textStyle: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              SizedBox(
                  height:
                      _isSetTimer ? screenHeight * 0.04 : screenHeight * 0.15),
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
                      color: const Color.fromARGB(255, 85, 88, 90),
                      borderRadius:
                          BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정
                    ),
                    child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Expanded(
                child: Container(
                  color: Colors.lightGreen,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  _timer.cancel();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.alarm, size: 55),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '소리폭탄',
                                              style: TextStyle(
                                                  fontSize: screenWidth * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'x5',
                                              style: TextStyle(
                                                  fontSize: screenWidth * 0.035,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        width: 70.0,
                        height: 70.0,
                        right: selected ? 0.0 : 50.0,
                        duration: const Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                            ref.watch(counterProvider.notifier).increment();
                          },
                          child: const ColoredBox(
                            color: Colors.blue,
                            child: Center(child: Text('Tap me')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
