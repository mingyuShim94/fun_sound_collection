import 'package:flutter/material.dart';
import 'package:happy_button/Screens/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happy_button/native_api/local_notification.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_button/provider/counter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.

  void loadBombCount() async {
    final SharedPreferences sharedBombCount =
        await SharedPreferences.getInstance();
    final int bombCount = sharedBombCount.getInt('bombCount') ?? 10;
    print('bombCount, $bombCount');
    ref.watch(counterProvider.notifier).setCount(bombCount);
  }

  @override
  void initState() {
    super.initState();
    loadBombCount();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification.requestPermission();
    return MaterialApp(localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ], supportedLocales: const [
      Locale('en', ''), // English
      Locale('ko', ''), // korean
    ], home: HomeScreen());
  }
}
