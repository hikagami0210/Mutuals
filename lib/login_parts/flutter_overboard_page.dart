// import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:music_fun/login_parts/registration.dart';
import 'login.dart';


class FlutterOverboardPage extends StatefulWidget {
  const FlutterOverboardPage({Key? key, required this.lang}) : super(key: key);

  final String lang;

  @override
  State<FlutterOverboardPage> createState() => _FlutterOverboardPageState();
}

class _FlutterOverboardPageState extends State<FlutterOverboardPage> {
  @override
  Widget build(BuildContext context) {

    // var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: OverBoard(
        skipText: "スキップ",
        finishText: "次へ",
        pages: pages,
        showBullets: true,
        skipCallback: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Registration();
          }));
        },
        finishCallback: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Registration();
          }));
        },
      ),
    );
  }

  final pages = [
    PageModel.withChild(
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: const Image(
                  image: AssetImage('assets/backGround_OverBoard.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Mutualsへようこそ!",style: TextStyle(fontSize: 40,color: Colors.white)),
                SizedBox(height: 30),
                Text("このアプリは",style: TextStyle(fontSize: 20,color: Colors.white)),
                SizedBox(height: 10),
                Text("音楽の話題に特化したSNSです",style: TextStyle(fontSize: 20,color: Colors.white)),
                Opacity(opacity: 0,
                child: Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",maxLines: 1,style: TextStyle(fontSize: 20,color: Colors.white))),
              ],
            ))
          ],
        ),
        color: Colors.transparent),
    PageModel.withChild(
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: const Image(
                  image: AssetImage('assets/backGround_OverBoard.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("ボード",style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 30),
                Text("趣味の合う友達を見つけましょう",style: TextStyle(fontSize: 20,color: Colors.white)),
                SizedBox(height: 30),
                FittedBox(fit:BoxFit.fitWidth,child: Text("フォローすると投稿がホームに表示されます",style: TextStyle(fontSize: 20,color: Colors.white))),
                SizedBox(height: 10),
                Opacity(opacity: 0,
                    child: Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",maxLines: 1,style: TextStyle(fontSize: 20,color: Colors.white))),
              ],
            ))
          ],
        ),
        color: Colors.transparent),
    PageModel.withChild(
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: const Image(
                  image: AssetImage('assets/backGround_OverBoard.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("ホーム",style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 30),
                Text("いいと思った曲を投稿したり...",style: TextStyle(fontSize: 20,color: Colors.white)),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(fit:BoxFit.fitWidth,child: Text("フォローしたアカウントの投稿が表示されます",style: TextStyle(fontSize: 20,color: Colors.white))),
                ),
                SizedBox(height: 10),
                Opacity(opacity: 0,
                    child: Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",maxLines: 1,style: TextStyle(fontSize: 20,color: Colors.white))),
              ],
            ))
          ],
        ),
        color: Colors.transparent),
  ];

  // Widget _selectedlangString(lang){
  //   if(lang == "Japanese") {
  //     setState(() {
  //
  //     });
  //     return
  //   }else{
  //
  //   }
  // }
}