import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService extends ChangeNotifier{

  var readTimelinecount = 0;

  static Future<List<Post>> fetchTimeLinePost() async {
    final db = FirebaseFirestore.instance;
    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    QuerySnapshot homePost =  await db.collectionGroup('timeline')
        .where('allowedUsers', arrayContains:uid)
        .orderBy('createdAt', descending: true)
        .get();

    List<Post> followingPost =
        homePost.docs.map((doc)=> Post.fromDoc(doc)).toList();

    return followingPost;
  }//ホーム画面タイムライン取得

  static Future<List<Post>> fetchAllPosts() async {
    final db = FirebaseFirestore.instance;

    QuerySnapshot allPost =  await db.collectionGroup('timeline')
        .orderBy('createdAt', descending: true)
        .get();

    List<Post> allPosts =
    allPost.docs.map((doc)=> Post.fromDoc(doc)).toList();

    return allPosts;
  }

  static Future<List<Post>> fetchSelectUserPosts(id) async {

    QuerySnapshot homePost =  await FirebaseFirestore.instance.collection('users').doc(id).collection('timeline')
        .orderBy('createdAt', descending: true)
        .get();

    List<Post> selectUserPost =
    homePost.docs.map((doc)=> Post.fromDoc(doc)).toList();

    return selectUserPost;
  }//ユーザー詳細画面ポスト取得

  static Future<List<Post>> fetchSelectUserLikedPosts(id) async {

    final db = FirebaseFirestore.instance;
    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    QuerySnapshot homePost =  await db.collectionGroup('timeline')
        .where('likedUsers', arrayContains:uid)
        .orderBy('createdAt', descending: true)
        .get();

    List<Post> selectUserLikedPosts =
    homePost.docs.map((doc)=> Post.fromDoc(doc)).toList();

    return selectUserLikedPosts;
  } //ユーザー詳細画面いいねしたポスト取得

  static Future<List<UserTile>> fetchUserTile(followingUserIdList) async {

    QuerySnapshot followingUserInstance =  await FirebaseFirestore.instance.collection('users').where('authID', whereIn:followingUserIdList).get();

    List<UserTile> followingPost =
    followingUserInstance.docs.map((doc)=> UserTile.fromDoc(doc)).toList();

    return followingPost;
  } //UserTile取得 follower following

}

class Post {

  String postUserId;
  String postID;
  String? text;
  Timestamp createdAt;
  int    likesCount;
  List allowedUsers;
  List? likedUsers;
  List? blockedUsers;
  String? tags;
  String? imageURL;

  Post(
      {
        this.text,
        required this.postID,
        required this.postUserId,
        required this.likesCount,
        required this.createdAt,
        required this.allowedUsers,
        this.likedUsers,
        this.blockedUsers,
        this.tags,
        this.imageURL,
      });

  factory Post.fromDoc(DocumentSnapshot doc){
    return Post(
      postUserId  : doc['postUserId'],
      postID      : doc['postID'],
      text        : doc['text'],
      likesCount  : doc['likesCount'],
      createdAt   : doc['createdAt'],
      allowedUsers: doc['allowedUsers'],
      tags        : doc['tags'],
      imageURL    : doc['imageURL'],
      blockedUsers : doc['blockedUsers'],
      likedUsers  : doc['likedUsers'],
    );
  }
}

class UserTile {

  String authID;
  String? bio;
  Timestamp? birthday;
  List followThread;
  String? locate;
  String name;
  String userID;

  UserTile(
      {
        required this.authID,
        required this.followThread,
        required this.name,
        required this.userID,
        this.bio,
        this.birthday,
        this.locate,
      });

  factory UserTile.fromDoc(DocumentSnapshot doc){
    return UserTile(
      authID       : doc['authID'],
      followThread : doc['followThread'],
      name         : doc['name'],
      userID       : doc['userID'],
      bio          : doc['bio'],
      birthday     : doc['birthday'],
      locate       : doc['locate'],
    );
  }
}



// final db = FirebaseFirestore.instance;
// db.collectionGroup('timeline')
//     .where('allowed_users', arrayContains:_uid)
//     .orderBy('created_at', descending: true)
//     .get()
//     .then((QuerySnapshot snapshot) {
//   snapshot.docs.forEach((doc) {
//     // print(doc["userID"]);
//     // print(doc["created_at"]);
//     // print(doc["allowed_users"]);
//     print(doc.data());
//     final at = doc["created_at"];
//     print(at.toDate());
//     if(readTimelinecount == 0){
//       print(snapshot.docs.length);
//       readTimelinecount++;
//     }
//
//   });
// });


// toList() {
//   return{
//     "text"        : text,
//     "postUserId"  : postUserId,
//     "likesCount"  : likesCount,
//     "created_at"  : created_at,
//     "allowed_users": allowed_users,
//     "tags"        : tags,
// };
//}

// Post.fromList(Map<dynamic, dynamic> map) {
//   text = map['text'];
//   postUserId = map['postUserId'];
//   likesCount = map['likesCount'];
//   created_at = map['created_at'];
// }
