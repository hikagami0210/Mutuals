//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'main_model.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider<MainModel>(
//         create: (_) => MainModel()..fetchBooks(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('ライバー 一覧'),
//           ),
//           body: Column(
//             children: [
//               Consumer<MainModel>(
//                 builder: (context, model, child) {
//                   final books = model.names;
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: books.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(books[index].name),
//                       );
//                     },
//                   );
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   FirebaseFirestore.instance.collection('users').add({
//                     'name' : 'test'
//                   });
//                 }, child: const Text("追加"),
//
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
