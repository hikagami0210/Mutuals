import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_fun/main_page/Homepage/user_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'home_page.dart';


String createTimeAgoString(DateTime postDateTime) {
  final now = DateTime.now();
  final difference = now.difference(postDateTime);
  return timeago.format(now.subtract(difference), locale: "ja");
}


class PostCard extends StatefulWidget {

  const PostCard({Key? key, this.text, this.tags, required this.postUserId, required this.createdAt, required this.likesCount, this.imageURL, required this.postID, required this.index,this.blockdusers}) : super(key: key);

  final String? text;
  final String? tags;
  final String postUserId;
  final Timestamp createdAt;
  final int likesCount;
  final String? imageURL;
  final String postID;
  final int index;
  final List? blockdusers;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? "Account Error";
  bool _isMyPost = false;
  bool _isLikedPost = false;
  bool _isImageDisplay = false;


  @override
  void initState(){
    super.initState();
    Future(() async {
    await _getUserIcon(widget.postUserId);
    await _getUserName(widget.postUserId);
    _likesCount = widget.likesCount.toInt();
    _isLikedPosts();
    if(widget.imageURL == ""){
      _isImageDisplay = false;
    }else{
      _isImageDisplay = true;
      _getPostImage(widget.imageURL);
    }
    if(widget.postUserId == _uid){
      _isMyPost = true;
    }

    if (kDebugMode) {
      print("${widget.index} : ${widget.text} : ${widget.imageURL} : $_isImageDisplay : $_postImage : $_isLikedPost");
    }

  });}

  ImageProvider<Object>? _userIcon;
  String? _postUserName;
  String? _postedUserID;
  Image? _postImage;

  int _likesCount = 0;

  double size = 50;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final topHeight = screenSize.height * 0.09;
    final postHeader = screenSize.height * 0.05;

    String nonNullPostUserName = _postUserName ?? "error";
    String nonNullPostedUserID = _postedUserID ?? "error";

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: topHeight,
                      width: topHeight,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserDetailPage(selectedUserId: _postedUserID.toString(), selectedUserIcon: _userIcon, selectedUserName: nonNullPostUserName, selectedUserUid: widget.postUserId)),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:_userIcon == null ? const AssetImage('assets/def_icon.png') : _userIcon  as ImageProvider<Object>,
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: postHeader,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 8,
                              child: SizedBox(
                                width: screenSize.width * 0.61,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Transform.scale(
                                          alignment: Alignment.centerLeft,
                                          scale: 1,
                                          child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                _postUserName ??
                                                    "--------",
                                              ))),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                  "@$_postedUserID   ${createTimeAgoString(widget.createdAt.toDate())}"),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child:_isMyPost ?  IconButton(
                                  icon: const Icon(Icons.menu),onPressed:(){
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: screenSize.height * 0.075,
                                        child:ListTile(
                                          leading: const Icon(Icons.close),
                                          title: const Text('投稿の削除'),
                                          onTap: (){
                                                    _deletePost();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                      );
                                    },
                                  );
                                },
                                ) : Container(),
                              ),
                            )
                          ],
                        ),
                      ), //name,id
                      widget.text == "" ? Container() : Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(widget.text.toString()),
                            ),
                          ),
                        ],
                      ),

                      _postImage == null && widget.imageURL == "" && _isImageDisplay == true ? Container() : Padding(padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),child: _postImage,),

                      SizedBox(
                        height: screenSize.height * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(padding: const EdgeInsets.all(0),constraints: const BoxConstraints(),onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
                            Row(
                              children: [
                                _likesIconButton(),
                                _likesCountText(_likesCount),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        const Divider(
          height: 25,
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Colors.black,
        ),
        //end
      ],
    );
  }

  _getUserIcon(postUserId)async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child("user_icon").child(postUserId+".png");
    String imageUrl = await imageRef.getDownloadURL();

    setState(() {
      _userIcon = NetworkImage(imageUrl);
    });
  }

  _getUserName(id)async{
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();
    setState(() {
      _postUserName = ref.get("name");
      _postedUserID   = ref.get("userID");
    });
  }

  Future _getPostImage(imageURL)async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child("Post").child(widget.imageURL.toString());
    String imageUrl = await imageRef.getDownloadURL();
    setState(() {
      _postImage = Image.network(imageUrl);
    });
  }

  _likesCountText(C){
    if(C > 0){
      return Text(C.toString());
    }else{
      return Container();
    }
  }

 Future _deletePost()async{
   FirebaseFirestore.instance.collection('users').doc(_uid).collection('timeline').doc(widget.postID).delete();
   if(widget.imageURL == ""){
   }else{
     FirebaseStorage storage = FirebaseStorage.instance;
     Reference imageRef = storage.ref().child("Post").child(widget.imageURL.toString());
     await imageRef.delete();
   }
 }

 Future _isLikedPosts()async {
   try{
     await FirebaseFirestore.instance.doc('users/${widget.postUserId}/timeline/${widget.postID}').get().then((docSnapshot) =>
     {
       if(docSnapshot["likedUsers"].toString().contains(_uid))
         {
           // 既に登録されているドキュメントの場合
           setState((){
             _isLikedPost = true;
           })
         }
       else
         {
           setState((){
             _isLikedPost = false;
           })
         }
     });
   }catch(e){
     setState((){
       _isLikedPost = false;
     });
   }
 }

 Future _likePost()async{
   final int likesCountIncrement = widget.likesCount + 1;
   await FirebaseFirestore.instance.collection('users').doc(widget.postUserId).collection('timeline').doc(widget.postID).update({'likesCount': likesCountIncrement });
   await FirebaseFirestore.instance.collection('users').doc(widget.postUserId).collection('timeline').doc(widget.postID).update(
     {
       "likedUsers": FieldValue.arrayUnion([_uid]),
     },
   );
 }

  Future _removeLikePost()async{
    final int likesCountDecrement = _likesCount - 1;
    await FirebaseFirestore.instance.collection('users').doc(widget.postUserId).collection('timeline').doc(widget.postID).update({'likesCount': likesCountDecrement});
    await FirebaseFirestore.instance.collection('users').doc(widget.postUserId).collection('timeline').doc(widget.postID).update(
      {
        "likedUsers": FieldValue.arrayRemove([_uid]),
      },
    );
  }

 Widget _likesIconButton(){
    if(_isLikedPost == true){
      return IconButton(constraints: const BoxConstraints(),padding: const EdgeInsets.all(0),onPressed: () async {
        _removeLikePost();
        setState(() {
          _likesCount = _likesCount - 1;
          _isLikedPost = !_isLikedPost;
        });
      }, icon: const Icon(Icons.thumb_up_alt,color: Colors.pinkAccent,));
    }else{
      return IconButton(padding: const EdgeInsets.all(0),constraints: const BoxConstraints(),onPressed: () {
        _likePost();
        setState(() {
          _likesCount = _likesCount + 1;
          _isLikedPost = !_isLikedPost;
        });
      }, icon: const Icon(Icons.thumb_up_alt_outlined));
    }
 }
}



// Padding(//start
// padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
// child: Container(
// child: Column(
// children: [
// Row(
// children: [
// Expanded(
// flex: 3,
// child: SizedBox(
// height: topHeight,
// child: Container(
// decoration: const BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.white,
// ),
// child:CircleAvatar(
// backgroundColor: Colors.white,
// backgroundImage: _userIcon == null ? const AssetImage('assets/inui.png') : _userIcon  as ImageProvider<Object>),
// ),
// )),
// const Expanded(flex :1, child: SizedBox(),),
// Expanded(
// flex: 8,
// child: Container(
// alignment: Alignment.centerLeft,
// height: topHeight,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// FittedBox(
// child: Text(
// _PostUserName ?? "",
// style: TextStyle(fontSize: 25),
// ),
// ),
// Container(alignment:Alignment.centerLeft,child: Text("@$_PostUserID" ?? "")),
// ],
// ),
// )),
// Expanded(flex :2,child: Container(child:FittedBox(fit: BoxFit.fitWidth,child: Text(createTimeAgoString(widget.createdAt.toDate()))))),
// Expanded(
// flex: 2,
// child: SizedBox(
// height: topHeight,
// child: const Icon(Icons.graphic_eq_rounded),
// )),
// ],
// ),
// Padding(
// padding: EdgeInsets.fromLTRB(7, 7, 7, 10),
// child: Text(widget.text.toString()),
// ),
// _postImage == null ? Container() : Padding(padding: EdgeInsets.fromLTRB(7, 0, 0, 0),child: _postImage,),
// Container(
// height: bottomHeight,
//
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Row(
// children: const [
// Icon(Icons.chat_bubble),Text("0"),
// ],
// ),
// Row(
// children: const [
// Icon(Icons.circle),Text("9")
// ],
// ),
// Row(
// children: [
// const Icon(Icons.thumb_up),
// Text(widget.likesCount.toString()),
// ],
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// ),