import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_fun/login_parts/login.dart';
import 'package:music_fun/sub_page/lang_setting_page.dart';
import 'package:music_fun/sub_page/theme_setting_Page.dart';
import 'package:settings_ui/settings_ui.dart';

import 'language_set.dart';

class settingPage extends StatefulWidget {
  const settingPage({Key? key}) : super(key: key);

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 130,
            child: SettingsList(
              sections: [
                SettingsSection(
                  tiles: [
                  SettingsTile(
                    title: Text('言語'),
                    leading: Icon(Icons.language),
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => lang(),
                          ));
                    },
                  ),
                  SettingsTile(
                    title: Text('テーマカラー'),
                    leading: Icon(Icons.palette_outlined),
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => theme(),
                          ));
                    },
                  ),
                ],),

              ],
            ),
          ),
          ListTile(leading: Icon(Icons.account_circle_rounded),title: Text("ログアウト"),onTap: (){
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Login();
            }));
          },)
        ],
      ),

    );
  }
}
