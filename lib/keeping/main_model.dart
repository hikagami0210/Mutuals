// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:music_fun/test.dart';
//
// class MainModel extends ChangeNotifier {
//   // ListView.builderで使うためのBookのList booksを用意しておく。　
//   List<Nijiname> names = [];
//
//   Future<void> fetchBooks() async {
//     // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
//     final docs = await FirebaseFirestore.instance.collection('nijisanji').get();
//
//     // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
//     // map(): Listの各要素をBookに変換
//     // toList(): Map()から返ってきたIterable→Listに変換する。
//     final names = docs.docs
//         .map((doc) => Nijiname(doc))
//         .toList();
//     this.names = names;
//     notifyListeners();
//   }
// }