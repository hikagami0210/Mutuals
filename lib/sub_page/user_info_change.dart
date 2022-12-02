import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../login_parts/user_info_register.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {

  final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'Login Error';


  DateTime? _birthday;
  String _birtdaycheck = "";

  String username = "";
  String userID = "";
  String bio = "";
  String locate = "";

  String iconfile = 'assets/inui.png';

  File? _iconfile;

  Color hinttextcoloer = Colors.black;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Text("ユーザー情報変更", style: TextStyle(fontSize: 30)),
            // Text(_email),

            const Text("アイコン画像"),
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
                backgroundImage: _iconfile == null
                    ? AssetImage(iconfile)
                    : Image.file(_iconfile!, fit: BoxFit.cover).image,
                // _iconfile == null ? AssetImage(iconfile) : Image.file(_iconfile!,fit: BoxFit.cover).image,
              ),
              // child: Image.asset('assets/inui.png',fit: BoxFit.fill),
            ),
            ElevatedButton(
                onPressed: _iconpicker, child: const Text("ファイルから選択")),

            const Text("ユーザーネーム"),
            TextFormField(
              decoration: InputDecoration(
                  hintText:"ctest ",
                  hintStyle: TextStyle(color: hinttextcoloer)),
              onChanged: (String value) {
                username = value;
              },
            ),

            const Text("ID"),
            TextFormField(
              decoration: InputDecoration(
                  hintText:"tesuto ",
                  hintStyle: TextStyle(color: hinttextcoloer)),
              onChanged: (String value) {
                userID = value;
              },
            ),

            Text("ロケーション$locate"),
            TextFormField(
              maxLength: 15,
              onChanged: (String value) {
                locate = value;
              },
            ),

            Text("誕生日 : " "$_birtdaycheck"),
            ElevatedButton(
                onPressed: () => _birthdayPicker(context),
                child: const Text("変更")),

            const Text("bio"),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String value) {
                bio = value;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (locate != "") {
                    FirebaseFirestore.instance
                        .doc('users/$_uid')
                        .update({'locate': locate});
                  } //locate登録処理
                  if (bio != "") {
                    FirebaseFirestore.instance
                        .doc('users/$_uid')
                        .update({'bio': bio});
                  } //bio登録処理
                  if (_birthday != null) {
                    FirebaseFirestore.instance
                        .doc('users/$_uid')
                        .update({'birthday': _birthday});
                  }
                  if (username != "") {
                    FirebaseFirestore.instance
                        .doc('users/$_uid')
                        .update({'name': username});

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const UserProfileRegister();
                    }));

                  } //username登録処理
                },
                child: const Text("保存 ")), //完了ボタン

            ElevatedButton(onPressed: () async{

              // final QuerySnapshot idcheck = await FirebaseFirestore.instance
              //     .collection('IDtest')
              //     .where('name', isEqualTo: userID)
              //     .get();

              if (!mounted) return;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const UserProfileRegister();
                  }));
            }, child: const Text("test=>register"), ),
          ],
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
        _birtdaycheck = "${date.year}年${date.month}月${date.day}日 ";
      });
    }
  } //birthdayPicker_method

  void _iconpicker() async {
    // imagePickerで画像を選択する
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
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } //iconPicker_method

}

// class userInfoChange extends ConsumerWidget {
//   const userInfoChange({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';
//     final String _email = FirebaseAuth.instance.currentUser?.email.toString() ?? 'ログインユーザーemail取得失敗';
//
//     DateTime? _birthday;
//     String _birtdaycheck = "";
//
//     String username = "";
//     String bio = "";
//     String locate = "";
//
//     String iconfile = 'assets/inui.png';
//
//     File? _iconfile;
//
//     Color hinttextcoloer = Colors.black;
//


//
// class userInfoChange extends StatefulWidget {
//   const userInfoChange({Key? key}) : super(key: key);
//
//   @override
//   State<userInfoChange> createState() => _userInfoChangeState();
// }
//
// class _userInfoChangeState extends State<userInfoChange> {
//
//   final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';
//   final String _email = FirebaseAuth.instance.currentUser?.email.toString() ?? 'ログインユーザーemail取得失敗';
//
//   DateTime? _birthday;
//   String _birtdaycheck = "";
//
//   String username = "";
//   String bio = "";
//   String locate = "";
//
//   String iconfile = 'assets/inui.png';
//
//   File? _iconfile;
//
//   Color hinttextcoloer = Colors.black;
//
//
//   @override
//   Widget build(BuildContext context) {
//     final username =
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             const SizedBox(
//               height: 30,
//             ),
//             const Text("ユーザー情報登録", style: TextStyle(fontSize: 30)),
//             // Text(_email),
//
//             const Text("アイコン画像"),
//             Container(
//               width: 150,
//               height: 150,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.blue,
//               ),
//               child: CircleAvatar(
//                 radius: 150,
//                 backgroundColor: Colors.white,
//                 backgroundImage: _iconfile == null ? AssetImage(iconfile) : Image.file(_iconfile!,fit: BoxFit.cover).image,
//                 // _iconfile == null ? AssetImage(iconfile) : Image.file(_iconfile!,fit: BoxFit.cover).image,
//               ),
//               // child: Image.asset('assets/inui.png',fit: BoxFit.fill),
//             ),
//             ElevatedButton(onPressed: _iconpicker, child: const Text("ファイルから選択")),
//
//             Text("ユーザーネーム"),
//             TextFormField(
//               decoration: InputDecoration(hintText: userName.toString(),hintStyle: TextStyle(color: hinttextcoloer)),
//               onChanged: (String value) {
//                 username = value;
//               },
//             ),
//
//             Text("ロケーション$locate"),
//             TextFormField(
//               maxLength: 15,
//               onChanged: (String value) {
//                 locate = value;
//               },
//             ),
//
//             Text("誕生日 : ""$_birtdaycheck"),
//             ElevatedButton(onPressed: () => _birthdayPicker(context),
//                 child: const Text("日付選択")),
//
//             const Text("bio"),
//           TextFormField(
//             keyboardType: TextInputType.multiline,
//             maxLines: null,
//             onChanged: (String value){
//               bio = value;
//             },
//            ),
//             ElevatedButton(onPressed: (){
//               if(locate != ""){
//                 FirebaseFirestore.instance.doc('users/$_uid').set({'locate': locate},SetOptions(merge: true));
//               }//locate登録処理
//               if(bio != ""){
//                 FirebaseFirestore.instance.doc('users/$_uid').set({'bio': bio},SetOptions(merge: true));
//               }//bio登録処理
//               if(_birthday != null){
//                 FirebaseFirestore.instance.doc('users/$_uid').set({'birthday': _birthday },SetOptions(merge: true));
//               }
//               if(username != ""){
//                 FirebaseFirestore.instance.doc('users/$_uid').set({'name': username},SetOptions(merge: true));
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return welcome(uid: _uid, iconfile: _iconfile,username: username);
//                 }));
//               }else{
//                 setState(() {
//                   hinttextcoloer = Colors.red;
//                 });
//               }//username登録処理
//             }, child: const Text("保存 ")),//完了ボタン
//           ],),
//       ),
//     );
//   }
//
//   Future _birthdayPicker(BuildContext context) async {
//     final DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900, 1, 1),
//       lastDate: DateTime.now(),
//     );
//
//     if (date != null) {
//       setState(() {
//         _birthday = date;
//         _birtdaycheck = "${date.year}年${date.month}月${date.day}日 ";
//       });
//     }
//   } //birthdayPicker_method
//
//   void _iconpicker() async {
//     // imagePickerで画像を選択する
//     final pickerFile =
//     await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickerFile == null) {
//       return;
//     }
//     File file = File(pickerFile.path);
//     FirebaseStorage storage = FirebaseStorage.instance;
//     try {
//       await storage.ref("user_icon/$_uid.png").putFile(file);
//       setState(() {
//         _iconfile = File(pickerFile.path);
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   } //iconPicker_method
//
// }
