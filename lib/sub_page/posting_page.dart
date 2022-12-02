import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Widget_Parts/showConfirmDialog.dart';

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  XFile? _pickimage;
  final imagePicker = ImagePicker();
  String randomImageURL = "";
  String randomPostID = "";

  int count = 0;

  String _text = "";
  String _imageURL = "";
  final String _postUserId = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";
  DateTime? _createdAt;
  final int _likesCount = 0;
  String? _tags;
  List _allowedUsers = [];
  List _blockedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: TextFormField(
                  maxLines: 35,
                  minLines: 16,
                  maxLength: 200,
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: '投稿',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(
                        width: 5,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    _text = value;
                  },
                ),
              ),
            ),
          ),
          _pickImage(),
          Container(
            color: Colors.grey,
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onLongPress: () => {getImageFromCamera()},
                    child: IconButton(
                        onPressed: () {
                          getImageFromGarally();
                        },
                        icon: const Icon(Icons.image))),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on_outlined)),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.local_offer)),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        )),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      print(_postUserId);
                      print(randomImageURL);
                      print(randomPostID);
                      print(_text);
                      // showProgressDialog();
                      try {
                        await _getListsForTimeline();
                        await _generateNonce();
                        // await _getBlockedUsersList();

                        print("00----------------------------");
                        print("1");
                        print("00----------------------------");

                        if (_pickimage == null) {
                        }else{
                          await _uploadImage();
                        }

                        print("00----------------------------");
                        print("2");
                        print("00----------------------------");

                        _createdAt = DateTime.now();
                        if (_text == "" && _imageURL == "") {
                        } else {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_postUserId)
                              .collection('timeline') // コレクションID指定
                              .doc(randomPostID)
                              .set({
                            'postID': randomPostID,
                            'postUserId': _postUserId,
                            'text': _text,
                            'createdAt': _createdAt,
                            'likesCount': _likesCount,
                            'tags': _tags,
                            'imageURL': _imageURL,
                            'allowedUsers': _allowedUsers,
                            'likedUsers' : [],
                            'blockedUsers' : _blockedUsers,
                          });

                          print("00----------------------------");
                          print(3);
                          print("00----------------------------");
                        }
                      } catch (e) {
                        print("00----------------------------");
                        print(e);
                        print("00----------------------------");
                        showAlertDialog(context,
                            title: "エラー",
                            content: "何らかの理由で投稿できませんでした。時間をおいてやり直してみてください");
                      }

                      print(_postUserId);
                      print(randomImageURL);
                      print(randomPostID);
                      print(_text);

                      if (!mounted) return;
                      Navigator.pop(context);
                      // Navigator.popUntil(context, (_) => count++ >= 2);
                    },
                    child: const Text(" 投稿 "))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickImage() {
    if (_pickimage == null) {
      return Container();
    } else {
      return GestureDetector(
          child: SizedBox(
              width: 80, height: 80, child: Image.file(File(_pickimage!.path))),
          onTap: () {
            showGeneralDialog(
              transitionDuration: const Duration(milliseconds: 1000),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return DefaultTextStyle(
                  style: Theme.of(context).primaryTextTheme.bodyText1!,
                  child: Center(
                    child: SizedBox(
                      height: 500,
                      width: 500,
                      child: SingleChildScrollView(
                          child: InteractiveViewer(
                            minScale: 0.1,
                            maxScale: 5,
                            child: Image.file(File(_pickimage!.path)),
                      )),
                    ),
                  ),
                );
              },
            );
          });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _pickimage = XFile(pickedFile.path);
      }
    });
  } //カメラからImage取得

  // ギャラリーから画像を取得するメソッド
  Future getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _pickimage = XFile(pickedFile.path);
      }
    });
  } //ギャラリーからImage取得

  _getListsForTimeline() async {
    final listsForTimeline = await FirebaseFirestore.instance
        .collection('users')
        .doc(_postUserId)
        .collection('listsForTimeline')
        .doc('id')
        .get();

    setState(() {
      _allowedUsers = listsForTimeline['userlist'];
    });
  }

  _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref("Post/$randomImageURL.png")
          .putFile(File(_pickimage!.path));
      setState(() {
        _imageURL = "$randomImageURL.png";
      });
    } catch (e) {
      return;
    }
  }

  _generateNonce([int length = 4]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-_';
    final random = Random.secure();
    final randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    DateFormat outputFormat = DateFormat('yyyyMMddHmss');
    final nowTime = DateTime.now();
    final randomStr2 =
        List.generate(20, (_) => charset[random.nextInt(charset.length)])
            .join();
    setState(() {
      randomImageURL = randomStr + outputFormat.format(nowTime).toString();
      randomPostID = randomStr2 + outputFormat.format(nowTime).toString();
    });
  }

  // Future _getBlockedUsersList()async{
  //   final blockUserList = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_postUserId)
  //       .collection('blockedUsers')
  //       .doc('blockedUsers')
  //       .get();
  //
  //   setState(() {
  //     _blockedUsers = blockUserList['blockedUsersList'];
  //   });
  // }

  void showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
