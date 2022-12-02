import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:music_fun/main_page/main_page_navi.dart';
import 'package:music_fun/sub_page/language_set.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart'  as timeago;

final langProvider = StateProvider((ref) => 'ja');
final themeProvider = StateProvider((ref) => ThemeData(primaryColor: Colors.blue));

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  timeago.setLocaleMessages("ja", timeago.JaMessages());


  String setLang = prefs.getString('setLang') ?? 'ja';

  setTheme(){
     String t = prefs.getString('setTheme') ?? 'light';
     switch(t) {
       case 'light':
         return ThemeData(primaryColor: Colors.blue);
       case 'dark':
         return ThemeData.dark();
       default:
         return ThemeData(primaryColor: Colors.blue);
    }
  }

  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  

  runApp(
    ProviderScope(
      overrides: [
        langProvider.overrideWithProvider(StateProvider((ref) => setLang)),
        themeProvider.overrideWithProvider(StateProvider((ref) => setTheme()))
      ],

      child: const ProviderScope(child:MyApp()),
    ),

  );
}

String createTimeAgoString(DateTime postDateTime) {
  final now = DateTime.now();
  final difference = now.difference(postDateTime);
  return timeago.format(now.subtract(difference), locale: "ja");
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja'),
          Locale('en'),
        ],
        locale: Locale(ref.watch(langProvider).toString()),
        title: 'Mutuals',
        theme: ref.watch(themeProvider),
        home: BaseTabView(),
      );
    } else {
      return MaterialApp(
        theme: ref.watch(themeProvider),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja'),
          Locale('en'),
        ],
        locale: Locale(ref.watch(langProvider).toString()),
        title: 'Mutuals',
        home: const LanguageSet(),
      );
    }
  }
}
