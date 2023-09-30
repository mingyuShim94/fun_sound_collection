import 'package:flutter/material.dart';
import 'package:happy_button/Screens/detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happy_button/native_api/local_notification.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> text = [
    'fart',
    'clipper',
    'plate',
    'scissors',
    'xxxxhub',
    'burp',
    'bone',
    'mosquito',
    'cat',
    'horn',
    'car',
    'chicken',
    'birthday',
    'slap',
    'scream',
  ];

  String subText(int index, BuildContext context) {
    String localeText;
    if (index == 0) {
      localeText = AppLocalizations.of(context)!.fart;
    } else if (index == 1) {
      localeText = AppLocalizations.of(context)!.clipper;
    } else if (index == 2) {
      localeText = AppLocalizations.of(context)!.plate;
    } else if (index == 3) {
      localeText = AppLocalizations.of(context)!.scissors;
    } else if (index == 4) {
      localeText = AppLocalizations.of(context)!.xxxxhub;
    } else if (index == 5) {
      localeText = AppLocalizations.of(context)!.burp;
    } else if (index == 6) {
      localeText = AppLocalizations.of(context)!.bone;
    } else if (index == 7) {
      localeText = AppLocalizations.of(context)!.mosquito;
    } else if (index == 8) {
      localeText = AppLocalizations.of(context)!.cat;
    } else if (index == 9) {
      localeText = AppLocalizations.of(context)!.horn;
    } else if (index == 10) {
      localeText = AppLocalizations.of(context)!.car;
    } else if (index == 11) {
      localeText = AppLocalizations.of(context)!.chicken;
    } else if (index == 12) {
      localeText = AppLocalizations.of(context)!.birthday;
    } else if (index == 13) {
      localeText = AppLocalizations.of(context)!.slap;
    } else if (index == 14) {
      localeText = AppLocalizations.of(context)!.scream;
    } else {
      localeText = 'error';
    }
    return localeText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade300,
        title: Text(
          AppLocalizations.of(context)!.title,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          mainAxisSpacing: 5.0,
          crossAxisCount: 3, // 열의 수
          children: List.generate(15, (index) {
            // 각 셀에 사각형 추가
            final imagePath = 'assets/images/image${index + 1}.jpg';
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                        imagePath: imagePath,
                        id: index,
                        name: subText(index, context)),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: 120.0, // 사각형의 가로 길이
                    height: 120.0, // 사각형의 세로 길이
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subText(index, context),
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 7.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Hero(
                                tag: imagePath,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Image(
                                    image: AssetImage(imagePath),
                                    width: 75.0,
                                    height: 75.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
