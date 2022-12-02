// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'login2.dart';
//
// class Register extends StatefulWidget {
//   const Register({Key? key}) : super(key: key);
//
//   @override
//   _RegisterState createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//
//   final _auth = FirebaseAuth.instance;
//
//   String email = '';
//   String password = '';
//
//   bool _isDisabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('新規登録'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: TextField(
//               onChanged: (value) {
//                 email = value;
//               },
//               decoration: const InputDecoration(
//                 hintText: 'メールアドレスを入力',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: TextField(
//               onChanged: (value) {
//                 password = value;
//               },
//               obscureText: true,
//               decoration: const InputDecoration(
//                 hintText: 'パスワードを入力',
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed:_isDisabled ? null :() async {
//               setState(() => _isDisabled = true);
//
//               try {
//                 final newUser = await _auth.createUserWithEmailAndPassword(
//                     email: email, password: password);
//                 if (newUser != null) {
//                   if (!mounted) return;
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => const MainContent()));
//                 }
//               } on FirebaseAuthException catch (e) {
//                 if (e.code == 'email-already-in-use') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('指定したメールアドレスは登録済みです'),
//                     ),
//                   );
//                   if (kDebugMode) {
//                     print('指定したメールアドレスは登録済みです');
//                   }
//                 } else if (e.code == 'invalid-email') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('メールアドレスのフォーマットが正しくありません'),
//                     ),
//                   );
//                   if (kDebugMode) {
//                     print('メールアドレスのフォーマットが正しくありません');
//                   }
//                 } else if (e.code == 'operation-not-allowed') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('指定したメールアドレス・パスワードは現在使用できません'),
//                     ),
//                   );
//                   if (kDebugMode) {
//                     print('指定したメールアドレス・パスワードは現在使用できません');
//                   }
//                 } else if (e.code == 'weak-password') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('パスワードは６文字以上にしてください'),
//                     ),
//                   );
//                   if (kDebugMode) {
//                     print('パスワードは６文字以上にしてください');
//                   }
//                 }
//               }
//               await Future.delayed(
//                 const Duration(seconds: 2), //無効にする時間
//               );
//
//               setState(() => _isDisabled = false);
//             },
//             child: const Text('新規登録'),
//           )
//         ],
//       ),
//     );
//   }
// }
//
