// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_overboard/flutter_overboard.dart';
// import 'auth_check.dart';
// import 'login2.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(debugShowCheckedModeBanner:false,home:FlutterOverboardPage()));
// }
//
// class FlutterOverboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OverBoard(
//         pages: pages,
//         showBullets: true,
//         skipCallback: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return Auth_check();
//           }));
//         },
//         finishCallback: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return Auth_check();
//           }));
//         },
//       ),
//     );
//   }
//
//
//   final pages = [
//     PageModel(
//         color: const Color(0xFF95cedd),
//         imageAssetPath: 'assets/inui.png',
//         title: 'テストだよ',
//         body: 'アプリのチュートリアル',
//         doAnimateImage: true),
//     PageModel(
//         color: const Color(0xFF9B90BC),
//         imageAssetPath: 'assets/inui.png',
//         title: 'テストだよ',
//         body: '複数ページ',
//         doAnimateImage: true),
//     PageModel.withChild(
//         child: Padding(
//             padding: EdgeInsets.only(bottom: 25.0),
//             child: Text(
//               "さあ、始めましょう",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 32,
//               ),
//             )),
//         color: const Color(0xFF5886d6),
//         doAnimateChild: true)
//   ];
// }
//
