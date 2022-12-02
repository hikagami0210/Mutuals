import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_fun/main_page/user_tile.dart';
import 'get_post_model.dart';

class FollowerList extends StatefulWidget {
  const FollowerList({Key? key, required this.selectUserUid}) : super(key: key);


  final String selectUserUid;

  @override
  State<FollowerList> createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {

  String _isLoadingFollowerList = "false";

  // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";

  List _followerUserIdList = [];
  List _listFollowerUserTile = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      _getFollowerUserTile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("フォロワーリスト"),),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FutureBuilder(
                  future: _getFollowerUserTile(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch(_isLoadingFollowerList) {
                      case "false":
                        return const CircularProgressIndicator();
                      case "true":
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _listFollowerUserTile.length,
                          itemBuilder: (BuildContext context, int index) {
                            return UserTileWidget(
                              authID: _listFollowerUserTile[index].authID,
                              followThread: _listFollowerUserTile[index].followThread,
                              name: _listFollowerUserTile[index].name,
                              userID: _listFollowerUserTile[index].userID,
                              bio: _listFollowerUserTile[index].bio,
                              birthday: _listFollowerUserTile[index].birthday.toDate(),
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

  Future _getFollowerUserIdList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.selectUserUid).collection('followers').get();
    final  val = querySnapshot.docs.map((doc) => doc.id).toList();

    if(val.isEmpty == true){
      setState(() {
        _isLoadingFollowerList = "nonFollow";
      });
    }else{
      setState(() {
        _followerUserIdList = val;
      });
    }
  }

  Future _getFollowerUserTile()async{
    if (_isLoadingFollowerList == "false") {
      await _getFollowerUserIdList();
      if (_isLoadingFollowerList == "nonFollow") {
      } else {
        await _fetchTimeLinePosts(_followerUserIdList);
        _isLoadingFollowerList = "true";
      }
    } else {}
    return _getFollowerUserTile;
  }

  Future _fetchTimeLinePosts(followerUserIdList)async {
    if(_isLoadingFollowerList == "false") {
      List<UserTile> fetchTimeLinePosts = await FirebaseService.fetchUserTile(followerUserIdList);
      setState(() {
        _listFollowerUserTile = fetchTimeLinePosts;
        _isLoadingFollowerList = "true";
      });
    }else{}
    return _fetchTimeLinePosts;
  }
}


