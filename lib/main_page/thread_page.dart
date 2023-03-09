import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../login_parts/aaaaa.dart';
import '../login_parts/flutter_overboard_page.dart';
import '../login_parts/login.dart';
import '../login_parts/registration.dart';
import '../login_parts/user_info_register.dart';
import '../login_parts/welcome.dart';
import '../sub_page/language_set.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadPage extends StatelessWidget {
  const ThreadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";
    final threadBarHeight = screenSize.height * 0.05;
    final threadTile = screenSize.height * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("フォーラム"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width * 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26, //枠線の色
                    width: 2, //枠線の太さ
                  ),
                ),
              ),
              height: 39,
              child: const Text("  お気に入り", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 5),
            threadtile(context, "〇〇について話そう", true),
            threadtile(context, "おすすめのアーティストを紹介する", false),
            threadtile(context, "東方原曲を語る part27", false),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width * 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26, //枠線の色
                    width: 2, //枠線の太さ
                  ),
                ),
              ),
              height: 39,
              child: const Text("  人気ランキング", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 5),
            threadtile(context, "Jpop総合 part334", false),
            threadtile(context, "ボカロ曲総合 part127", false),
            threadtile(context, "アニソン総合 part173 " , false),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width * 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26, //枠線の色
                    width: 2, //枠線の太さ
                  ),
                ),
              ),
              height: 39,
              child: Row(
                children: const [
                  Text("  履歴                                                           ", style: TextStyle(fontSize: 20)),
                  Icon(Icons.expand_less),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width * 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26, //枠線の色
                    width: 2, //枠線の太さ
                  ),
                ),
              ),
              height: 39,
              child: Row(
                children: const [
                  Text("  検索                                                           ", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 80,
                  width: screenSize.width * 0.47,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    child: Center(child: Text("アーティスト名から探す")),
                  ),
                ),
                Container(
                  height: 80,
                  width: screenSize.width * 0.47,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    child: Center(child: Text(" ジャンルから探す")),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget threadtile(
    C,
    title,
    bool1,
  ) {
    var screenSize = MediaQuery.of(C).size;

    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.07,
          width: screenSize.width * 9,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Colors.black26,
              ),
            ),
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  $title",
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                    child: Row(
                        children: [
                          bool1 ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    " 新着 6 ",
                                    style: TextStyle(fontSize: 15,color: Colors.white),
                                  ),
                                )
                              : Container(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz,
                                size: 20,
                              )),
                        ],
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
