import 'package:flutter/material.dart';
import 'package:happy_button/Screens/detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_button/provider/counter_provider.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        //MyID
        'android': 'ca-app-pub-8647279125417942~7035645273',
      }
    : {
        //testID
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final counterProvider = StateNotifierProvider((ref) => Counter());
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    ref.listen(counterProvider, ((prev, next) {
      print('현재상태: $prev, $next');
    }));
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    Locale currentLocale = Localizations.localeOf(context);

    bool isKorean = currentLocale.languageCode == 'ko';
    print(isKorean);
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: const AdRequest(),
    )..load();

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade300,
        title: Text(
          AppLocalizations.of(context)!.title,
          style: TextStyle(
            fontSize: screenHeight * 0.04, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: screenHeight * 0.02), // Responsive padding
        child: GridView.count(
          mainAxisSpacing: screenHeight * 0.001, // Responsive spacing
          crossAxisCount: 3, // Number of columns
          children: List.generate(15, (index) {
            final imagePath = 'assets/images/image${index + 1}.jpg';
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      imagePath: imagePath,
                      id: index,
                      name: AppLocalizations.of(context)!
                          .sound_name(index.toString()),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: screenWidth * 0.31, // Responsive width
                    height: screenWidth * 0.31, // Responsive height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          screenWidth * 0.01), // Responsive padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .sound_name(index.toString()),
                            style: TextStyle(
                              fontSize: isKorean
                                  ? screenHeight * 0.02
                                  : screenHeight *
                                      0.026, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.01), // Responsive spacing
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
                                  width: screenWidth * 0.2, // Responsive width
                                  height:
                                      screenWidth * 0.2, // Responsive height
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.amber.shade300,
        height: screenHeight * 0.06, // Responsive height
        child: AdWidget(ad: banner),
      ),
    );
  }
}
