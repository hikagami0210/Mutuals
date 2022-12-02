import 'package:intl/intl.dart';
import 'package:music_fun/login_parts/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class eeeeeee extends StatefulWidget {
  const eeeeeee({Key? key}) : super(key: key);

  @override
  State<eeeeeee> createState() => _eeeeeeeState();
}

class _eeeeeeeState extends State<eeeeeee> {
  
  final String _uid =
      FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';

  DateTime? _birthday;
  String _birtdaycheck = "";
  bool isIDcheck = false;
  String username = "";
  String bio = "";
  String locate = "";
  String userID = "";

  bool _isIcon = false;

  Color userIDTextColor = Colors.black;

  String iconfile = 'assets/inui.png';

  File? _iconfile;

  Color hinttextcoloer = Colors.black;

  String landID = "";
  bool _isIdOk = false;

  @override
  Widget build(BuildContext context) {
    String idformHintText = AppLocalizations.of(context)!.user_ID_hintText;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          SizedBox(
            height: screenSize.height * 0.2,
            width: screenSize.width * 1,
            child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset(
                    "assets/User_Profile_image.png")),
            // color: Colors.red,
          ),
          Container(
            transform: Matrix4.translationValues(0, -35, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.25,
                      height: screenSize.width * 0.25,
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/icon_add1.png')),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.08,
                      width: screenSize.width * 0.70,
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.05,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Transform.scale(
                                      alignment: Alignment.center,
                                      scale: 1,
                                      child:FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "dddddddddddd"
                                          ),
                                        ),
                                      )),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text("ssssssssssssss@"),
                                        ))),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.3,
                            child: Center(
                              child: Container(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: screenSize.width * 0.95,
                  height: 300,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.red,
                          width: 100,
                          height: 300,
                        ),
                        Container(),
                        Container(),
                      ]),
                )
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.black,
          ),
        ]),
      ),
    );
  }

  Future _birthdayPicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _birthday = date;
        _birtdaycheck = "${date.year}/${date.month}/${date.day}";
      });
    }
  } //birthdayPicker_method

  void _iconpicker() async {
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
    File file = File(pickerFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref("user_icon/$_uid.png").putFile(file);
      setState(() {
        _iconfile = File(pickerFile.path);
        _isIcon = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } //iconPicker_method

  generateID([int length = 12]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random.secure();
    final randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    setState(() {
      userID = randomStr;
    });
  }

  _idCheck(e) async {
    await FirebaseFirestore.instance
        .doc('IDtest/$e')
        .get()
        .then((docSnapshot) => {
              if (docSnapshot.exists)
                {
                  // 既に登録されているドキュメントの場合
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.user_ID_check_error),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'ok',
                      onPressed: () {},
                    ),
                  )),
                  _idcheckboolChangerFalse(),
                }
              else
                {
                  _isIdOk = true,
                  _idcheckboolChangerTrue(),
                }
            });
  }

  _idcheckboolChangerTrue() {
    setState(() {
      isIDcheck = true;
      userIDTextColor = Colors.blue;
    });
  }

  _idcheckboolChangerFalse() {
    setState(() {
      isIDcheck = false;
      userIDTextColor = Colors.red;
    });
  }
}
