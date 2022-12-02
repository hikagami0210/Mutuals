import 'package:flutter/material.dart';
import 'package:music_fun/sub_page/setting_page.dart';
import 'package:music_fun/sub_page/user_info_change.dart';

class myPage extends StatefulWidget {
  const myPage({Key? key}) : super(key: key);

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("My page"),automaticallyImplyLeading: false,centerTitle: true,),
      body: Column(
        children: [
          Container(
            height: screenSize.height * 0.3,
            width: double.infinity,
            color: Colors.grey,
          ),
          ListTile(
            shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                )
            ),

            leading: const Icon(Icons.person),
            title: const Text("ユーザー情報変更"),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ));
            },
          ),
          ListTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey,
                style: BorderStyle.solid,
              )
            ),

            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => settingPage(),
                  ));
            },
          ),

        ],

    )
    );
  }
}






