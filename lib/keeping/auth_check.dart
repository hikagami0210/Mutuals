// import 'login2.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class Auth_check extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // スプラッシュ画面などに書き換えても良い
//             return const SizedBox();
//           }
//           if (snapshot.hasData) {
//             // User が null でなない、つまりサインイン済みのホーム画面へ
//             return MainContent();
//           }
//           // User が null である、つまり未サインインのサインイン画面へ
//           return UserLogin();
//         },
//       ),
//     );
//   }
// }