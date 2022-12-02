import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_fun/main_page/user_tile.dart';
import 'Homepage/get_post_model.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({Key? key,required this.selectedUserUid}) : super(key: key);

  final String selectedUserUid;

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {

  String _isLoadingFollowingList = "false";
  // bool _nonFollow = false;

  final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";

  List _followingUserIdList = [];
  List _listFollowingUserTile = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      _getFollowingUserTile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("フォローリスト"),),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FutureBuilder(
                  future: _getFollowingUserTile(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch(_isLoadingFollowingList) {
                      case "false":
                        return const CircularProgressIndicator();
                      case "true":
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _listFollowingUserTile.length,
                          itemBuilder: (BuildContext context, int index) {
                            return UserTileWidget(
                                authID: _listFollowingUserTile[index].authID,
                                followThread: _listFollowingUserTile[index].followThread,
                                name: _listFollowingUserTile[index].name,
                                userID: _listFollowingUserTile[index].userID,
                                bio: _listFollowingUserTile[index].bio,
                                birthday: _listFollowingUserTile[index].birthday.toDate(),
                                index : index,
                            );
                          },
                        );
                      case "nonFollow":
                        return Center(child: Text("フォローしていません"),);
                      default:
                        return const CircularProgressIndicator();
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getFollowingUserIdList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.selectedUserUid).collection('following').get();
    final  val = querySnapshot.docs.map((doc) => doc.id).toList();

    if(val.isEmpty == true){
      setState(() {
        _isLoadingFollowingList = "nonFollow";
      });
    }else{
      setState(() {
        _followingUserIdList = val;
      });
    }

  }

  Future _getFollowingUserTile() async {
    if (_isLoadingFollowingList == "false") {
      await _getFollowingUserIdList();
      if (_isLoadingFollowingList == "nonFollow") {

      } else {
        print(_isLoadingFollowingList);
        await _fetchFollowingUserData(_followingUserIdList);
        _isLoadingFollowingList = "true";
      }
    } else {}
    return _getFollowingUserTile;
  }

  Future _fetchFollowingUserData(followingUserIdList)async {
    if(_isLoadingFollowingList == "false") {
      List<UserTile> fetchFollowingUserData = await FirebaseService.fetchUserTile(followingUserIdList);
      setState(() {
        _listFollowingUserTile = fetchFollowingUserData;
        _isLoadingFollowingList = "true";
      });
    }else{}
    return _fetchFollowingUserData;
  }
}


