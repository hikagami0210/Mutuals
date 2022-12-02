import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Homepage/user_detail_page.dart';
import 'following_list.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserTileWidget extends StatefulWidget {
  const UserTileWidget(
      {Key? key, required this.authID, this.bio, this.birthday, required this.followThread, this.locate, required this.name, required this.userID, required int index})
      : super(key: key);

  // authID: _listFollowingUserTile[index].authID,
  // followThread: _listFollowingUserTile[index].followThread,
  // name: _listFollowingUserTile[index].name,
  // userID: _listFollowingUserTile[index].usereID,
  // index : index,

  final String authID;
  final String? bio;
  final DateTime? birthday;
  final List followThread;
  final String? locate;
  final String name;
  final String userID;

  @override
  State<UserTileWidget> createState() => _UserTileWidgetState();
}

class _UserTileWidgetState extends State<UserTileWidget> {

  ImageProvider<Object>? _userIcon;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   if (widget.bio == null) {
    //   } else {
    //     _setUserBio = widget.bio!;
    //   }
    //   _setUserID = widget.userID;
    //   _setUserName = widget.name;
    // });
    _getUserIcon(widget.authID);
  }

  // String _setUserID =  "  ";
  // String _setUserName = "  ";
  // String _setUserBio = "  ";

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDetailPage(selectedUserUid: widget.authID, selectedUserIcon: _userIcon, selectedUserName: widget.name, selectedUserId: widget.userID)),
        );
      },
      child: Container(
        height: screenSize.width * 0.2,

        child: Row(
          children: [

            Container(
              width: screenSize.width * 0.2,
              height: screenSize.width * 0.2,
              child: Center(
                child: SizedBox(
                  width: screenSize.width * 0.17,
                  height: screenSize.width * 0.17,
                  child: GestureDetector(
                    onTap: () {},
                    child:CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:_userIcon == null ? const AssetImage('assets/inui.png') : _userIcon  as ImageProvider<Object>,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.05,
                  height: screenSize.width * 0.2,
                ),
                SizedBox(
                  width: screenSize.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex:1,child: SizedBox.shrink()),
                      Expanded(flex:4,child: Transform.scale(
                          alignment: Alignment.centerLeft,
                          scale: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                               widget.name,
                              )))),
                      Expanded(flex:2,child: Transform.scale(
                          alignment: Alignment.centerLeft,
                          scale: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                               widget.userID,
                              )))),
                      Expanded(flex:2,child: Transform.scale(
                          alignment: Alignment.centerLeft,
                          scale: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                widget.bio ?? "",
                              )))),
                      const Expanded(flex:1,child: SizedBox.shrink()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _getUserIcon(postUserId)async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child("user_icon").child(postUserId+".png");
    String imageUrl = await imageRef.getDownloadURL();

    setState(() {
      _userIcon = NetworkImage(imageUrl);
    });
  }
}

