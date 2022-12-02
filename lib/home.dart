import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_parts/user_info_register.dart';

// [Themelist] インスタンスにおける処理。
class Home extends StatelessWidget {
  final String _uid =
      FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';

  // 新規追加ダイアログ用の入力文字の受け取り用変数
  final _roomnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const List<String> popmenulist = ["テスト", "ログアウト"];

    return Scaffold(
      // Header部分
      appBar: AppBar(
        // leading: Icon(Icons.home),
        title: const Text('ページタイトル'),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,

        // 右上メニューボタン
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (String s) {
              if (s == 'ログアウト') {
                FirebaseAuth.instance.signOut();

                Navigator.of(context).pushNamed("/login");
                // Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (BuildContext context) {
              return popmenulist.map((String s) {
                return PopupMenuItem(
                  value: s,
                  child: Text(s),
                );
              }).toList();
            },
          ),
        ],
      ),

      // メイン画面
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
            child: Text(_uid,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 300.0,
            height: 40.0,
            child: ElevatedButton(
                // ボタンの形状や背景色など
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, //text-color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ボタン１'),

                // ボタン１の処理内容（ポップアップを出し、何かを入力させる。）
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UserProfileRegister();
                  }));
                }),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: Text('または'),
          ),
          SizedBox(
            width: 300.0,
            height: 40.0,
            child: ElevatedButton(
                // ボタンの形状や背景色など
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.orange, //text-color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ボタン２'),
                // ボタン２の処理内容（ポップアップを出し、何かを入力させる。）
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('ダイアログ　タイトル'),
                          content: TextField(
                            //controller: dateTextController,
                            decoration: const InputDecoration(
                              hintText: '入力項目２',
                            ),
                            autofocus: true,
                            // keyboardType: TextInputType.number,
                            controller: _roomnameController,
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: const Text('キャンセル'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (kDebugMode) {
                                    print(_roomnameController);
                                  }
                                }),
                          ],
                        );
                      });
                }),
          ),
        ]),
      ),
    );
  }
}
