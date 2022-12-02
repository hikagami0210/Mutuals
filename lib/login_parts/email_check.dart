import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_fun/login_parts/user_info_register.dart';

class Emailcheck extends StatefulWidget {
  // 呼び出し元Widgetから受け取った後、変更をしないためfinalを宣言。
  final String? email;
  final String? pswd;
  final int? from; //1 → アカウント作成画面から    2 → ログイン画面から

  const Emailcheck({Key? key, @required this.email, this.pswd, this.from})
      : super(key: key);

  @override
  State<Emailcheck> createState() => _Emailcheck();
}

class _Emailcheck extends State<Emailcheck> {
  String _nocheckText = '';
  String _sentEmailText = '';
  int _btnClickNum = 0;

  // 前画面から受け取った値はNull許容のため、入れ直し用の変数を用意
  late String _email;
  late String _pswd;

  @override
  Widget build(BuildContext context) {
    _email = widget.email ?? '';
    _pswd = widget.pswd ?? '';

    // 前画面から遷移後の初期表示内容
    if (_btnClickNum == 0) {
      if (widget.from == 1) {
        // アカウント作成画面から遷移した時
        _nocheckText = '';
        _sentEmailText = '${widget.email}\nに確認メールを送信しました。';
      } else {
        _nocheckText = 'まだメール確認が完了していません。\n確認メール内のリンクをクリックしてください。';
        _sentEmailText = '';
      }
    }

    return Scaffold(
      // メイン画面
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 確認メール未完了時のメッセージ
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
              child: Text(
                _nocheckText,
                style: const TextStyle(color: Colors.red),
              ),
            ),

            // 確認メール送信時のメッセージ
            Text(_sentEmailText),

            // 確認メールの再送信ボタン
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30.0),
              child: ButtonTheme(
                minWidth: 200.0,
                // height: 100.0,
                child: ElevatedButton(
                  // ボタンの形状や背景色など
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.grey, //text-color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // ボタン内の文字や書式
                  child: const Text(
                    '確認メールを再送信',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  onPressed: () async {
                    UserCredential result =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email,
                      password: _pswd,
                    );

                    result.user!.sendEmailVerification();
                    setState(() {
                      _btnClickNum++;
                      _sentEmailText = '${widget.email}\nに確認メールを送信しました。';
                    });
                  },
                ),
              ),
            ),

            // メール確認完了のボタン配置（Home画面に遷移）
            SizedBox(
              width: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                // ボタンの形状や背景色など
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, //text-color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // ボタン内の文字や書式
                child: const Text(
                  'メール確認完了',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                onPressed: () async {
                  UserCredential result =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email,
                    password: _pswd,
                  );

                  // ログインユーザーのIDを取得
                  User? user = result.user;

                  // Email確認が済んでいる場合は、Home画面へ遷移
                  if (user != null && user.emailVerified) {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileRegister(),//email: _email,
                        ));
                  } else {
                    // print('NG');
                    setState(() {
                      _btnClickNum++;
                      _nocheckText =
                          "まだメール確認が完了していません。\n確認メール内のリンクをクリックしてください。";
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
