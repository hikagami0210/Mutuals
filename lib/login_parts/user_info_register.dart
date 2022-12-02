import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_fun/login_parts/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';


class UserProfileRegister extends StatefulWidget {
  const UserProfileRegister({Key? key}) : super(key: key);

  @override
  State<UserProfileRegister> createState() => _UserProfileRegisterState();
}

class _UserProfileRegisterState extends State<UserProfileRegister> {


  final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';

  DateTime? _birthday;
  String _birtdaycheck = "";
  bool isIDcheck = false;
  String username = "";
  String bio = "";
  String locate = "";
  String userID = "";

  bool _isIcon = false;

  Color userIDTextColor = Colors.black;

  String iconfile = 'assets/icon_add.png';

  File? _iconfile;

  Color hinttextcoloer = Colors.black;

  String landID = "";
  bool _isIdOk = true;

  @override
  void initState(){
    super.initState();
    generateID();
  }

  @override
  Widget build(BuildContext context) {
    String idformHintText = AppLocalizations.of(context)!.user_ID_hintText;
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Text(AppLocalizations.of(context)!.user_info_register_t, style: const TextStyle(fontSize: 30,color: Colors.white)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: GestureDetector(
                      onTap: _iconpicker,
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.white,
                        backgroundImage: _iconfile == null
                            ? AssetImage(iconfile)
                            : Image.file(_iconfile!, fit: BoxFit.cover).image,
                        // _iconfile == null ? AssetImage(iconfile) : Image.file(_iconfile!,fit: BoxFit.cover).image,
                      ),
                    ),
                    // child: Image.asset('assets/inui.png',fit: BoxFit.fill),
                  ),
                ),


                // TextFormField(
                //   cursorColor: Colors.white,
                //   style: const TextStyle(
                //     color: Colors.white,
                //   ),
                //   decoration: InputDecoration(
                //     contentPadding: const EdgeInsets.symmetric(
                //       vertical: 10,
                //     ),
                //     counterStyle: const TextStyle(color: Colors.white),
                //     hintText: AppLocalizations.of(context)?.usernameHint,
                //     hintStyle: const TextStyle(color: Colors.white),
                //     prefixIcon: const Icon(
                //       Icons.account_circle_rounded,
                //       color: Colors.white,
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(16),
                //       borderSide: const BorderSide(
                //         color: Colors.white,
                //         width: 2.0,
                //       ),
                //     ),
                //     labelStyle: const TextStyle(
                //       fontSize: 12,
                //       color: Colors.white,
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(16),
                //       borderSide: const BorderSide(
                //         color: Colors.white,
                //         width: 1.0,
                //       ),
                //     ),
                //   ),
                //   keyboardType: TextInputType.multiline,
                //   onChanged: (String value) {
                //     bio = value;
                //   },
                //   maxLength: 15,
                //   maxLines: 15,
                // ),

                SizedBox(
                  height: 15,
                ),
                Text(AppLocalizations.of(context)!.user_name,style: const TextStyle(color: Colors.white),),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLength: 20,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    counterStyle: const TextStyle(color: Colors.white),
                    hintText: AppLocalizations.of(context)?.usernameHint,
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(
                      Icons.account_circle_rounded,
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    username = value;
                  },
                ),

                SizedBox(
                  height: 15,
                ),
                Text(AppLocalizations.of(context)!.user_ID,style: const TextStyle(color: Colors.white),),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: screenSize.width * 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Focus(
                          child:TextFormField(
                            maxLength: 12,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[A-Za-z0–9]'))
                            ],////
                            controller: TextEditingController(text: userID),//
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              counterStyle: const TextStyle(color: Colors.white),
                              hintText: AppLocalizations.of(context)?.usernameHint,
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.account_circle_rounded,
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (String value) {
                              userID = value;
                            },
                          ),
                          // TextFormField(
                          //   controller: TextEditingController(text: userID),
                          //   style: TextStyle(color: userIDTextColor),
                          //   maxLength: 12,
                          //   inputFormatters: [
                          //     FilteringTextInputFormatter.allow(RegExp('[A-Za-z0–9]'))
                          //   ],
                          //   decoration: InputDecoration(
                          //       hintText: idformHintText,
                          //       hintStyle: TextStyle(color: hinttextcoloer)),
                          //   onChanged: (String value) {
                          //     userID = value;
                          //   },
                          // ),
                          // onFocusChange: (hasFocus){
                          //   if(!hasFocus){
                          //     if(userID.length >= 6 && userID.length <=12) {
                          //       setState(() {
                          //         _idcheckboolChangerTrue();
                          //       });
                          //     }else{
                          //       setState(() {
                          //         _idcheckboolChangerFalse();
                          //       });
                          //     }
                          //   }
                          // },
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //     child:
                      //         OutlinedButton(
                      //             style: OutlinedButton.styleFrom(
                      //               foregroundColor: Colors.white,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               side: const BorderSide(
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //             onPressed: (){
                      //           if(userID.length >= 6 && userID.length <=12){
                      //             _idCheck(userID);
                      //           }else{
                      //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //               content: Text(AppLocalizations.of(context)!.user_ID_check_error1,style: const TextStyle(color: Colors.white,),maxLines: 1,),
                      //               duration: const Duration(seconds: 3),
                      //               action: SnackBarAction(
                      //                 label: 'ok',
                      //                 onPressed: () {},
                      //               ),
                      //             ));
                      //             setState(() {
                      //               userIDTextColor = Colors.red;
                      //             });
                      //           }
                      //         }, child: Text(AppLocalizations.of(context)!.user_ID_check,style: const TextStyle(color: Colors.white,fontSize: 13),maxLines: 1,)))
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                Text("${AppLocalizations.of(context)!.user_location}$locate",style: const TextStyle(color: Colors.white),),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    counterStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(
                      Icons.pin_drop,
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    locate = value;
                  },
                  maxLength: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${AppLocalizations.of(context) !.user_birthday} :" "$_birtdaycheck",style: const TextStyle(color: Colors.white),),
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
                        onPressed: () => _birthdayPicker(context),
                        child: Text(AppLocalizations.of(context)!.birthday_picker)),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),
                Text(AppLocalizations.of(context) !.user_bio,style: const TextStyle(color: Colors.white),),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15
                    ),
                    counterStyle: const TextStyle(color: Colors.white),
                    // prefixIcon: const Icon(
                    //   Icons.book,
                    //   color: Colors.white,
                    // ),
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (String value) {
                    bio = value;
                  },
                  maxLength: 15,
                  maxLines: null,
                ),

                OutlinedButton(//NextPageButton
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _isIdOk == false
                        ? (){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!.user_ID_check_error2),
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'ok',
                          onPressed: () {},
                        ),
                      ));
                    }//ID確認が終わってない場合
                        : () async {
                            final prefs = await SharedPreferences.getInstance();
                            if (username != "") {

                              prefs.setString('userName', username);
                              FirebaseFirestore.instance.doc('users/$_uid').set(
                                  {'name': username}, SetOptions(merge: true));
                              //username登録

                              FirebaseFirestore.instance
                                  .doc('users/$_uid')
                                  .set({'userID': userID}, SetOptions(merge: true));
                              prefs.setString('userID', userID);
                              FirebaseFirestore.instance
                                  .doc('IDcheck/$userID')
                                  .set({'name': userID}, SetOptions(merge: true));
                              //userID登録

                              FirebaseFirestore.instance
                                  .doc('users/$_uid')
                                  .set({'isIcon': _isIcon}, SetOptions(merge: true));
                              prefs.setBool('isIcon', _isIcon);
                              //Iconの有無を登録

                              if (locate != "") {
                                FirebaseFirestore.instance
                                    .doc('users/$_uid')
                                    .set({'locate': locate}, SetOptions(merge: true));
                                prefs.setString('locate', locate);
                              }
                              //locate登録

                              if (bio != "") {
                                FirebaseFirestore.instance
                                    .doc('users/$_uid')
                                    .set({'bio': bio}, SetOptions(merge: true));
                                prefs.setString('bio', bio);
                              }
                              //bio登録

                              if (_birthday != null) {
                                FirebaseFirestore.instance.doc('users/$_uid').set(
                                    {'birthday': _birthday},
                                    SetOptions(merge: true));
                                prefs.setString('birthday', _birthday.toString());
                              }
                              //birthday登録処理
                              if (!mounted) return;
                              Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return WelcomePage(uid: _uid, iconfile: _iconfile, username: username);
                                }));//welcomePageへとばす

                              } else {//userName未入力
                                setState(() {
                                  hinttextcoloer = Colors.red;
                                });
                              }
                            }, //username登録処理
                    child: Text(AppLocalizations.of(context)!.user_info_register)), //完了ボタン
                const SizedBox(
                  height: 15,
                ),
                Text(AppLocalizations.of(context)!.user_info_hint_1,style: const TextStyle(color: Colors.white),),
                // Text(AppLocalizations.of(context)!.user_info_hint_2,style: const TextStyle(color: Colors.white),),

              ],
            ),
          ),
        ),
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
    final pickerFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
  }//iconPicker_method

  generateID([int length = 12]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random.secure();
    final randomStr =  List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    setState(() {
      userID = randomStr;
    });
  }

  _idCheck(e)async{
    await FirebaseFirestore.instance.doc('IDtest/$e').get().then((docSnapshot) => {
              if (docSnapshot.exists)
                {
                  // 既に登録されているドキュメントの場合
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.user_ID_check_error),
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

  _idcheckboolChangerTrue(){
    setState(() {
      isIDcheck = true;
      userIDTextColor = Colors.blue;
    });
  }

  _idcheckboolChangerFalse(){
    setState(() {
      isIDcheck = false;
      userIDTextColor = Colors.red;
    });
  }

}




// ローカルにファイルを書き込み
// Directory appDocDir = await getApplicationDocumentsDirectory();
// File downloadToFile = File("${appDocDir.path}/download-logo.png");
// try {
//   await imageRef.writeToFile(downloadToFile);
// } catch (e) {
//   print(e);
// }