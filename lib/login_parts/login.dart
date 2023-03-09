import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../main_page/main_page_navi.dart';
import 'authentication_error.dart';
import 'registration.dart';
import 'email_check.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  String _loginEmail = "";
  String _loginPassword = "";
  String _infoText = "";
  bool _isObscure =  true;
  final authError = AuthenticationErrorToJa();
  // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";



  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // メールアドレスの入力フォーム
              Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      labelText: AppLocalizations.of(context)!.emailAddress,
                      floatingLabelStyle: const TextStyle(fontSize: 12,color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onChanged: (String value) {
                      _loginEmail = value;
                    },
                  )),

              // パスワードの入力フォーム
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                child: TextFormField(
                  obscureText: _isObscure,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20)
                  ],
                  decoration: InputDecoration(

                    labelText: AppLocalizations.of(context)!.passWord,
                    suffixIcon: IconButton(
                      // 文字の表示・非表示でアイコンを変える
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,color: Colors.white,),
                      // アイコンがタップされたら現在と反対の状態をセットする
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    floatingLabelStyle: const TextStyle(fontSize: 12,color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    _loginPassword = value;
                  },
                )
              ),

              // ログイン失敗時のエラーメッセージ
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                child: Text(
                  _infoText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

              SizedBox(
                width: 350.0,
                // height: 100.0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  // ボタン内の文字と書式
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  onPressed: () async {
                    try {
                      UserCredential result =
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _loginEmail,
                        password: _loginPassword,
                      );
                      // ログイン成功
                      User? user = result.user; // ログインユーザーのIDを取得

                      // Email確認が済んでいる場合のみHome画面へ
                      if (user != null && user.emailVerified) {
                        if (!mounted) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BaseTabView(),
                            ));
                      } else {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Emailcheck(
                                  email: _loginEmail,
                                  pswd: _loginPassword,
                                  from: 2)),
                        );
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(authError.loginErrorMsg(e.hashCode, e.toString()));
                      }
                      // ログインに失敗した場合
                      setState(() {
                        _infoText =
                            authError.loginErrorMsg(e.hashCode, e.toString());
                      });
                    }
                  },
                ),
              ),
              // ログイン失敗時のエラーメッセージ
              TextButton(
                child:Text(AppLocalizations.of(context)!.sendResetEmail,style: const TextStyle(color: Colors.white)),
                onPressed: () => FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _loginEmail),
              ),
            ],
          ),
        ),

        bottomNavigationBar:
        Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 350.0,
              // height: 100.0,
              child: OutlinedButton(
                  // ボタンの形状や背景色など
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.newAccountCreate,
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => const Registration(),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 15),
//   child: TextFormField(
//     obscureText: _isObscure,
//     maxLengthEnforcement: MaxLengthEnforcement.enforced,
//     cursorColor: Colors.white,
//     style: const TextStyle(
//       color: Colors.white,
//     ),
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(20)
//     ],
//     decoration: InputDecoration(
//
//       labelText: AppLocalizations.of(context)!.passWord,
//       suffixIcon: IconButton(
//         // 文字の表示・非表示でアイコンを変える
//         icon: Icon(
//             _isObscure ? Icons.visibility_off : Icons.visibility),
//         // アイコンがタップされたら現在と反対の状態をセットする
//         onPressed: () {
//           setState(() {
//             _isObscure = !_isObscure;
//           });
//         },
//       ),
//       prefixIcon: const Icon(
//         Icons.mail,
//         color: Colors.white,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(
//           color: Colors.white,
//           width: 2.0,
//         ),
//       ),
//       labelStyle: const TextStyle(
//         fontSize: 12,
//         color: Colors.white,
//       ),
//       floatingLabelStyle: const TextStyle(fontSize: 12,color: Colors.white),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(
//           color: Colors.white,
//           width: 1.0,
//         ),
//       ),
//     ),
//     onChanged: (String value) {
//       _loginPassword = value;
//     },
//   ),),
