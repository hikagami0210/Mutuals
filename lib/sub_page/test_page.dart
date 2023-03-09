import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:music_fun/futu.dart';

import '../login_parts/aaaaa.dart';
import '../login_parts/flutter_overboard_page.dart';
import '../login_parts/login.dart';
import '../login_parts/registration.dart';
import '../login_parts/user_info_register.dart';
import '../login_parts/welcome.dart';
import 'language_set.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";

    final threadBarHeight = screenSize.height * 0.05;
    final threadTile = screenSize.height * 0.1;
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          overlayStyle: ExpandableFabOverlayStyle(color: Colors.black.withOpacity(0.5)),
          type: ExpandableFabType.up,
          distance: 60,
          children: [
            FloatingActionButton.extended(
              heroTag: "tagAdd",
              onPressed: () {},
              label: Text("タグを追加"),
              icon: Icon(Icons.add_box),
            ),
            FloatingActionButton.extended(
              heroTag: "ThreadAdd",
              icon: Icon(Icons.add),
              onPressed: () {}, label: Text("タグを追加"),
            ),
          ],),
        body: Column(
          children: [
            Container(
              height: threadBarHeight,
              color: Colors.red,
            ),
            Container(
              height: threadTile,

            ),
            Container(
              height: threadBarHeight,
              color: Colors.red,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
            }, child: Text("login")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlutterOverboardPage(lang: "Japanese",),
                  ));
            }, child: Text("FlutterOverboardPage")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Registration(),
                  ));
            }, child: Text("Registration")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileRegister(),
                  ));
            }, child: Text("UserProfileRegister")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(uid: "assssssss", username: 'test',),
                  ));
            }, child: Text("WelcomePage")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguageSet(),
                  ));
            }, child: Text("LanguageSet")),

            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => eeeeeee(),
                  ));
            }, child: Text("eeeeeee")),


            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Futu(),
                  ));
            }, child: Text("futu")),


          ],
        ));
  }
}
