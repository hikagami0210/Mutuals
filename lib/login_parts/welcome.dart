import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main_page/main_page_navi.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage( {Key? key, required this.uid, this.iconfile, required this.username}) : super(key: key);

  final String uid;
  final File? iconfile;
  final String username;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  String deficon = 'assets/inui.png';

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("ようこそ!",style: TextStyle(fontSize: 40,color: Colors.white),),
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.iconfile == null ? AssetImage(deficon) : Image.file(widget.iconfile!,fit: BoxFit.cover).image,
                  // _iconfile == null ? AssetImage(iconfile) : Image.file(_iconfile!,fit: BoxFit.cover).image,
                ),
                // child: Image.asset('assets/inui.png',fit: BoxFit.fill),
              ),

              Text("${widget.username}さん!",style: const TextStyle(fontSize: 40,color: Colors.white)),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (){
                try{
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.uid)
                      .collection('listsForTimeline') // コレクションID指定
                      .doc('id')
                      .set({
                    'userlist': [widget.uid],
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return BaseTabView();
                  }));
                }catch(e){
                  if (kDebugMode) {
                    print(e);
                  }
                }
              }, child: const Text("始める")),
              const SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
