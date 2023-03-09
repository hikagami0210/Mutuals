import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../following_list.dart';
import 'follower_list.dart';
import 'post_card.dart';
import 'get_post_model.dart';
import 'dart:math' as math;

class UserDetailPage extends StatefulWidget {
  const UserDetailPage(
      {Key? key,
      required this.selectedUserId,
      required this.selectedUserIcon,
      required this.selectedUserName,
      required this.selectedUserUid})
      : super(key: key);

  final String selectedUserId;
  final String selectedUserUid;
  final String selectedUserName;
  final ImageProvider<Object>? selectedUserIcon;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  //FireBaseAuth
  final String _uid =
      FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";

  //UserProfile
  String _bio = "";
  DateTime? _birthday;
  String _locate = "";
  int _followingUserCount = 0;
  int _followerCount = 0;

  int ran = 0;

  //uesFetchPost
  bool isFollow = false;
  bool _isLoading = false;
  List<Post> selectUserPosts = [];
  List<Post> selectUserLikedPosts = [];

  //TabBarController
  int _selectedTabbar = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    ran = randomIntWithRange(1, 5);
    _tabController = TabController(length: 2, vsync: this);
  }

  Future fetchPosts() async {
    if (_isLoading == false) {
      _getUserInfo(widget.selectedUserUid);
      _checkIsFollow(widget.selectedUserId);
      _linkedUserCount();

      DefaultTabController.of(context)?.index;

      List<Post> fetchSelectUserPosts =
          await FirebaseService.fetchSelectUserPosts(widget.selectedUserUid);
      List<Post> fetchSelectUserLikedPosts =
          await FirebaseService.fetchSelectUserLikedPosts(
              widget.selectedUserUid);

      setState(() {
        selectUserPosts = fetchSelectUserPosts;
        selectUserLikedPosts = fetchSelectUserLikedPosts;
        _isLoading = true;
      });
    } else {}
    return fetchPosts;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            height: screenSize.height * 0.2,
            width: screenSize.width * 1,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: randomImage(ran),
              // color: Colors.red,
            ),
            decoration: BoxDecoration(),
          ),
          Container(
              transform: Matrix4.translationValues(0, -35, 0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.25,
                      height: screenSize.width * 0.25,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: widget.selectedUserIcon == null
                            ? const AssetImage('assets/def_icon.png')
                            : widget.selectedUserIcon as ImageProvider<Object>,
                      ),
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
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(widget.selectedUserName),
                                      )),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child:
                                              Text("@${widget.selectedUserId}"),
                                        ))),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width * 0.3,
                            child: Center(
                                child: widget.selectedUserUid != _uid
                                    ? _followButton()
                                    : Container()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: screenSize.width * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bio == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(_bio),
                            ),
                      _locate == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                              child: Text(_locate),
                            ),
                      _birthday == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                              child: Text(DateFormat('yyyy-MM-dd')
                                  .format(_birthday!)
                                  .toString()),
                            ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FollowingList(
                                      selectedUserUid: widget.selectedUserUid);
                                },
                              ),
                            );
                          },
                          child: Container(
                            child: _followingUserCount == 0
                                ? const Text("フォロー ")
                                : Text("フォロー $_followingUserCount"),
                          ),
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FollowerList(
                                      selectUserUid: widget.selectedUserUid);
                                },
                              ),
                            );
                          },
                          child: Container(
                            child: _followerCount == 0
                                ? const Text("フォロワー ")
                                : Text("フォロワー $_followerCount"),
                          ),
                        )),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black,
                ),
              ])),

          Container(
            transform: Matrix4.translationValues(0, -35, 0),
            child: Column(children: [
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      onTap: (value) {
                        setState(() {
                          _isLoading = false;
                          _selectedTabbar = value;
                        });
                      },
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: const <Widget>[
                        Tab(
                          text: "投稿",
                        ),
                        Tab(
                          text: "いいね",
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: fetchPosts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (_isLoading) {
                            case false:
                              return Center(
                                  child: Container(
                                      transform:
                                          Matrix4.translationValues(0, 100, 0),
                                      child:
                                          const CircularProgressIndicator()));
                            case true:
                              return Container(child: _tabBarView());
                            default:
                              return Center(
                                  child: Container(
                                      transform:
                                          Matrix4.translationValues(0, 100, 0),
                                      child:
                                          const CircularProgressIndicator()));
                          }
                        }),
                  ],
                ),
              ),
            ]),
          ),

          // Flexible(
          //     child: RefreshIndicator(
          //       onRefresh: () async {
          //         setState(() {
          //           _isLoading = false;
          //         });
          //         await fetchPosts();
          //       },
          //       child:
        ]),
      ),
    );
  }

  Widget _tabBarView() {
    switch (_selectedTabbar) {
      case 0:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectUserPosts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
                text: selectUserPosts[index].text,
                tags: selectUserPosts[index].tags,
                createdAt: selectUserPosts[index].createdAt,
                postUserId: selectUserPosts[index].postUserId,
                likesCount: selectUserPosts[index].likesCount,
                imageURL: selectUserPosts[index].imageURL,
                postID: selectUserPosts[index].postID,
                index: index);
          },
        );
      case 1:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectUserLikedPosts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
                text: selectUserLikedPosts[index].text,
                tags: selectUserLikedPosts[index].tags,
                createdAt: selectUserLikedPosts[index].createdAt,
                postUserId: selectUserLikedPosts[index].postUserId,
                likesCount: selectUserLikedPosts[index].likesCount,
                imageURL: selectUserLikedPosts[index].imageURL,
                postID: selectUserLikedPosts[index].postID,
                index: index);
          },
        );
      default:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectUserLikedPosts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
                text: selectUserLikedPosts[index].text,
                tags: selectUserLikedPosts[index].tags,
                createdAt: selectUserLikedPosts[index].createdAt,
                postUserId: selectUserLikedPosts[index].postUserId,
                likesCount: selectUserLikedPosts[index].likesCount,
                imageURL: selectUserLikedPosts[index].imageURL,
                postID: selectUserLikedPosts[index].postID,
                index: index);
          },
        );
    }
  }

  Future<void> _getUserInfo(userID) async {
    final ref =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    setState(() {
      _bio = ref.get("bio");
      _birthday = ref.get("birthday").toDate();
      _locate = ref.get("locate");
    });
  }

  Future<void> _checkIsFollow(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('following')
        .doc(widget.selectedUserUid)
        .get()
        .then((docSnapshot) => {
              if (docSnapshot.exists)
                {
                  setState(() {
                    isFollow = true;
                  })
                }
              else
                {
                  setState(() {
                    isFollow = false;
                  })
                }
            });
  }

  Widget _followButton() {
    if (isFollow == true) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey,
          shape: const StadiumBorder(),
        ),
        onPressed: () async {
          _unFollow();
          setState(() {
            isFollow = !isFollow;
          });
        },
        child: const Text('unFollow'),
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue,
          shape: const StadiumBorder(),
        ),
        onPressed: () async {
          _following();
          setState(() {
            isFollow = !isFollow;
          });
        },
        child: const Text('Follow'),
      );
    }
  }

  Future _unFollow() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('following')
        .doc(widget.selectedUserUid)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.selectedUserUid)
        .collection('listsForTimeline')
        .doc('id')
        .update({
      "userlist": FieldValue.arrayRemove([_uid])
    });
  }

  Future _following() async {
    var now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('following')
        .doc(widget.selectedUserUid)
        .set({'createdat': now});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.selectedUserUid)
        .collection('listsForTimeline')
        .doc('id')
        .update({
      "userlist": FieldValue.arrayUnion([_uid])
    });
  }

  Future _linkedUserCount() async {
    AggregateQuerySnapshot getFollowerCount = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.selectedUserUid)
        .collection('followers')
        .count()
        .get();

    AggregateQuerySnapshot getFollowingUserCount = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.selectedUserUid)
        .collection('following')
        .count()
        .get();

    int gotFollowingUserCount = getFollowingUserCount.count;
    int gotFollowerCount = getFollowerCount.count;

    setState(() {
      _followingUserCount = gotFollowingUserCount;
      _followerCount = gotFollowerCount;
    });
  }

  int randomIntWithRange(int min, int max) {
    int value = math.Random().nextInt(max - min);
    return value + min;
  }

  randomImage(e) {
    switch (e) {
      case 1:
        return Image.asset("assets/User_Profile_image.png");
      case 2:
        return Image.asset("assets/User_Profile_image1.png");
      case 3:
        return Image.asset("assets/User_Profile_image2.png");
      case 4:
        return Image.asset("assets/User_Profile_image3.png");
      case 5:
        return Image.asset("assets/User_Profile_image4.png");
    }
  }
}

// SizedBox(
// height: 250 * selectUserPosts.length + 1,
// child: TabBarView(children: [
// ListView.builder(
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
// itemCount: selectUserPosts.length,
// itemBuilder: (BuildContext context, int index) {
// return PostCard(text: selectUserPosts[index].text,
// tags: selectUserPosts[index].tags,
// createdAt: selectUserPosts[index].createdAt,
// postUserId: selectUserPosts[index].postUserId,
// likesCount: selectUserPosts[index].likesCount,
// imageURL: selectUserPosts[index].imageURL,
// postID: selectUserPosts[index].postID,
// index: index);
// },
// ),
// ListView.builder(
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
// itemCount: selectUserLikedPosts.length,
// itemBuilder: (BuildContext context, int index) {
// return PostCard(text: selectUserLikedPosts[index].text,
// tags: selectUserLikedPosts[index].tags,
// createdAt: selectUserLikedPosts[index].createdAt,
// postUserId: selectUserLikedPosts[index].postUserId,
// likesCount: selectUserLikedPosts[index].likesCount,
// imageURL: selectUserLikedPosts[index].imageURL,
// postID: selectUserLikedPosts[index].postID,
// index: index);
// },
// ),
// ]),
// ),

// body: SingleChildScrollView(
//     child: Column(
//       children: <Widget>[
//         Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).padding.top,
//             ),
//             SizedBox(
//               height: screenSize.height * 0.2,
//               width: screenSize.width * 1,
//               child: FittedBox(fit:BoxFit.fill,child: Image.network("https://www.cyberpunk.net/build/images/edgerunners/phase2/cover-desktop@2x-3991b705.jpg")),
//               // color: Colors.red,
//             ),
//           ],
//         ),
//         Container(
//           transform: Matrix4.translationValues(0, -35, 0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   SizedBox(
//                     width: screenSize.width * 0.25,
//                     height: screenSize.width * 0.25,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       backgroundImage:widget.userIcon == null ? const AssetImage('assets/inui.png') : widget.userIcon  as ImageProvider<Object>,
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenSize.height * 0.08,
//                     width: screenSize.width * 0.70,
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: screenSize.width * 0.05,
//                         ),
//                         SizedBox(
//                           width: screenSize.width * 0.35,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 6,
//                                 child:Transform.scale(
//                                     alignment: Alignment.center,
//                                     scale: 1,
//                                     child: FittedBox(
//                                         fit: BoxFit.fitWidth,
//                                         child: Text(
//                                       widget.postUserName
//                                     ),)),
//
//                               ),
//                               Expanded(
//                                   flex: 4,
//                                   child: Container(
//                                       alignment: Alignment.centerLeft,
//                                       child: FittedBox(
//                                         fit: BoxFit.fitWidth,
//                                         child: Text(
//                                             "@${widget.postedUserId}"),
//                                       ))),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: screenSize.width * 0.3,
//                           child: Center(
//                             child: widget.postUserId != _uid ? _followButton() : Container()
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//           ),
//           SizedBox(
//             width: screenSize.width * 0.95,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _bio == "" ? Container() : Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                   child: Text(_bio),),
//                 _locate == "" ? Container() : Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
//                   child: Text(_locate),),
//                 _birthday == null ?  Container() : Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
//                   child: Text(DateFormat('yyyy-MM-dd').format(_birthday!).toString()),),
//               ],
//             ),
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(flex:1,child:Container(
//               )),
//               Expanded(flex:2,child:Container(
//                 child: _followingUserCount == 0 ? Container() :Text("フォロー $_followingUserCount"),
//               )),
//               Expanded(flex:1,child:Container(
//               )),
//               Expanded(flex:2,child:Container(
//                 child: _followerCount == 0 ? Container():Text("フォロワー $_followerCount"),
//               )),
//               Expanded(flex:1,child:Container(
//               )),
//             ],
//           ),
//
//           const Divider(
//             height: 20,
//             thickness: 1,
//             indent: 10,
//             endIndent: 10,
//             color: Colors.black,
//           ),
//           DefaultTabController(
//             length: 2,
//             child:
//             Column(
//               children: [
//                 TabBar(
//                   controller: _tabController,
//                   onTap: (value) {
//                     setState(() {
//                       _selectedTabbar = value;
//                     });
//                   },
//                   labelColor: Colors.black,
//                   unselectedLabelColor: Colors.grey,
//                   labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                   tabs: const <Widget>[
//                   Tab(text: "tui-to",),
//                   Tab(text: "wine",),],
//                 ),
//                 _tabBarView(),
//               ],
//             ),
//
//
//           ),
//        ] ),
//         )],
//     ),
// ),
