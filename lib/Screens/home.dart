import 'package:flutter/material.dart';
import 'package:happy_button/Screens/detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          mainAxisSpacing: 10.0,
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
              child: Hero(
                tag: imagePath,
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: 110.0, // 사각형의 가로 길이
                      height: 110.0, // 사각형의 세로 길이
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정,
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Container(
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          subText(index, context),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
