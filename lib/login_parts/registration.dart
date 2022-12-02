import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'authentication_error.dart';
import 'email_check.dart';
import 'login.dart';

// アカウント登録ページ
class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Firebase Authenticationを利用するためのインスタンス

  String _newEmail = ""; // 入力されたメールアドレス
  String _newPassword = ""; // 入力されたパスワード
  String _checkPassword = "";
  String _infoText = ""; // 登録に関する情報を表示
  bool _pswdOK = false; // パスワードが有効な文字数を満たしているかどうか

  // エラーメッセージを日本語化するためのクラス
  final authError = AuthenticationErrorToJa();

  bool _isObscure1 = true;
  bool _isObscure2 = true;




  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(
                  height: screenSize.height * 0.2,
                ),
                const Padding(padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0), child: Text('新規アカウントの作成', style: TextStyle(color:Colors.white,fontSize: 25, fontWeight: FontWeight.bold))),

                // メールアドレスの入力フォーム
                Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 15),
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
                        labelText: "メールアドレス",
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
                        _newEmail = value;
                      },
                    ),),

                // パスワードの入力フォーム
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 15.0),
                  child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure1 = !_isObscure1;
                              });
                            },
                            icon: Icon(_isObscure1
                                ? Icons.visibility_off
                                : Icons.visibility,color: Colors.white,)),
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
                        labelText: "パスワード（8～20文字）",
                        floatingLabelStyle: const TextStyle(fontSize: 12,color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      obscureText: _isObscure1,
                      // パスワードが見えないようRにする
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20)
                      ],
                      // 入力可能な文字数
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (String value) {
                        if (value.length >= 8) {
                          _newPassword = value;
                          _pswdOK = true;
                        } else {
                          _pswdOK = false;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                  child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon:
                        IconButton(
                            onPressed: (){
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            },
                            icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility,color: Colors.white,)),
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
                        labelText: "パスワード（確認用）",
                        floatingLabelStyle: const TextStyle(fontSize: 12,color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      obscureText: _isObscure2,
                      // パスワードが見えないようRにする
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20)
                      ],
                      // 入力可能な文字数
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (String value) {
                        if (value.length >= 8) {
                          _checkPassword = value;
                          _pswdOK = true;
                        } else {
                          _pswdOK = false;
                        }
                      }),
                ), // 登録失敗時のエラーメッセージ

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                  child: Text(
                    _infoText,
                    style: const TextStyle(color: Colors.red),
                  ),
                ), // アカウント作成のボタン配置

                SizedBox(
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
                    // ボタン内の文字と書式
                    child: const Text(
                      '登録',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_pswdOK && _checkPassword == _newPassword) {
                        try {
                          //メール/パスワードでユーザー登録
                          UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _newEmail,
                            password: _newPassword,
                          );
                          //登録成功
                          User user = result.user!; // 登録したユーザー情報
                          user.sendEmailVerification(); // Email確認のメールを送信
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Emailcheck(email: _newEmail, pswd: _newPassword, from: 1),
                              ));
                        }catch (e) {
                          // 登録に失敗した場合
                          setState(() {
                            _infoText = authError.registerErrorMsg(e.hashCode, e.toString());
                          });
                        }} else if(_checkPassword != _newPassword){
                        setState(() {
                           _infoText = 'パスワードと確認用パスワードが一致しません';
                        });}else{
                        setState(() {
                          _infoText = 'パスワードは8文字以上です。';
                        });}
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
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
                          "ログイン",
                          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) => const  Login(),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


