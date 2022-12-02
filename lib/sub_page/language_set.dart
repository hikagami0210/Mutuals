import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_parts/flutter_overboard_page.dart';
import '../main.dart';
import '../provider.dart';

class LanguageSet extends ConsumerStatefulWidget {
  const LanguageSet({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LanguageSetStateView();
}

class _LanguageSetStateView extends ConsumerState<LanguageSet> {
  String _lang = "Japanese";

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final String selectedLang = ref.watch(langSetupProvider).toString();

    // String snackBarText() {
    //   String selectedLang = ref.watch(langSetupProvider).toString();
    //   if (selectedLang.toString() == "Japanese") {
    //     return "言語を日本語に設定しました";
    //   } else {
    //     return "Language is set to English";
    //   }
    // }

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          // const Color(0xff5F11DE),
          Color(0xff24165D),
          Color(0xff0429CE)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenSize.width * 0.6,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    Image.asset('assets/appIcon_outline.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset('assets/Mutuals_Log.png'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const Text(
              "Please select the language you use",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButton(
                iconDisabledColor: Colors.white,
                iconEnabledColor: Colors.white,
                value: selectedLang,
                dropdownColor: const Color(0xff24165D),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: "Japanese",
                    child:
                        Text("Japanese", style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem<String>(
                    value: "English",
                    child:
                        Text("English", style: TextStyle(color: Colors.white)),
                  )
                ],
                onChanged: (String? value) {
                  ref.read(langSetupProvider.notifier).state = value;
                  _lang = value!;
                }),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  if (ref.read(langSetupProvider.notifier).state ==
                      "Japanese") {
                    ref.read(langProvider.notifier).state = 'ja';
                    prefs.setString('setLang', 'ja');
                  } else {
                    ref.read(langProvider.notifier).state = 'en';
                    prefs.setString('setLang', 'ja');
                    // ref.refresh(langProvider);
                  }

                  // final SnackBar snackBar = SnackBar(
                  //     content: Text(snackBarText()),
                  //     action: SnackBarAction(
                  //       label: 'ok',
                  //       onPressed: () {},
                  //     ));

                  if (!mounted) return;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return FlutterOverboardPage(
                      lang: _lang,
                    );
                  }));
                },
                child: const Text("OK")),
            SizedBox(
              height: 90,
              width: screenSize.width * 1,
            )
          ],
        ),
      ),
    );
  }
}

// class AppBackground extends StatelessWidget {
//   const AppBackground({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, contraint) {
//       final height = contraint.maxHeight;
//       final width = contraint.maxWidth;
//
//       return Stack(
//         children: <Widget>[
//           // Container(
//           //   color: Color(0xFFE4E6F1),
//           // ),
//           Positioned(
//             top: height * 0.50,
//             left: height * 0.35,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
//             ),
//           ),
//           Positioned(
//             top: height * 0.50,
//             left: height * 0.355,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: const BoxDecoration(
//                   shape: BoxShape.circle, color: Color(0xff5F11DE)),
//             ),
//           ),
//
//           Positioned(
//             top: height * 0.505,
//             left: height * 0.359,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
//             ),
//           ),
//           Positioned(
//             top: height * 0.505,
//             left: height * 0.365,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: const BoxDecoration(
//                   shape: BoxShape.circle, color: Color(0xff5F11DE)),
//             ),
//           ),
//
//
//           Positioned(
//             top: height * 0.10,
//             left: -height * 0.39,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.black.withOpacity(0.2)),
//             ),
//           ),
//           Positioned(
//             top: height * 0.10,
//             left: -height * 0.395,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: const BoxDecoration(
//                   shape: BoxShape.circle, color: Color(0xff5F11DE)),
//             ),
//           ),
//
//
//           Positioned(
//             top: -height * 0.50,
//             left: height * 0.15,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.black.withOpacity(0.2)),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

// class language_set extends ConsumerWidget {
//   language_set({
//     Key? key,
//   }) : super(key: key);
//  final _langlist =  <String>["Japanese","English"];
//  final _selectlang = "Japanese";
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Text(_selectlang),
//             DropdownButton(items: [
//               DropdownMenuItem<String>(
//                 value: _langlist[0], child: Text(_langlist[0]),)
//             ], onChanged: (String value){
//               se
//             }),
//
//           ],
//         ),
//       ),
//     ) ;
//   }
// }
