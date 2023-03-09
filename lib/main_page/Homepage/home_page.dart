import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_fun/main_page/Homepage/post_card.dart';
import '../../sub_page/posting_page.dart';
import '../../sub_page/test_page.dart';
import 'get_post_model.dart';

List<Post> listPost = [];


class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomepageStateView();
}

class _HomepageStateView extends ConsumerState<HomePageView> {

  bool _isLoading = false;

  // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';
  // final String _email = FirebaseAuth.instance.currentUser?.email.toString() ?? 'ログインユーザーemail取得失敗';
  Future fetchTimeLinePosts()async {
    await Future.delayed(const Duration(seconds: 1));
    if(_isLoading == false) {
      List<Post> fetchTimeLinePosts = await FirebaseService.fetchTimeLinePost();
      setState(() {
        listPost = fetchTimeLinePosts;
        _isLoading = true;
      });
    }else{}
    return fetchTimeLinePosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(),
                  ))
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Posting_button",
        onPressed:()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const PostingPage();
            }));setState(() {
              _isLoading = false;
            });
            fetchTimeLinePosts();
            },
        child: const Icon(Icons.add, size: 40),
      ),

      body: Center(
        child: Column(
          children: [

            Flexible(
              child: RefreshIndicator(
                edgeOffset:1000,
                onRefresh: () async {
                  setState(() {
                    _isLoading = false;
                  });
                    await fetchTimeLinePosts();
                },
                child: FutureBuilder(
                    future: fetchTimeLinePosts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      switch(_isLoading) {
                        case false:
                          return SpinKitWave(color: Colors.black.withOpacity(0.5),type: SpinKitWaveType.center);
                        case true:
                          return ListView.builder(
                            itemCount: listPost.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PostCard(text: listPost[index].text,
                                  tags: listPost[index].tags,
                                  createdAt: listPost[index].createdAt,
                                  postUserId: listPost[index].postUserId,
                                  likesCount: listPost[index].likesCount,
                                  imageURL: listPost[index].imageURL,
                                  postID: listPost[index].postID,
                                  index: index);
                            },
                          );
                        default:
                          return const SpinKitPianoWave(color: Colors.black,);
                      }
                    }
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}




// class CustomStyleArrow extends CustomPainter {
//   @override

//   ここから
//   CustomPaint(
//   painter: CustomStyleArrow(),
//   child: Container(
//   decoration: BoxDecoration(
//   color: Colors.red,
//   borderRadius: BorderRadius.circular(25)
//   ),
//   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
//   child: const Text("This is the custom painter for arrow down curve",
//   style: TextStyle(
//   color: Colors.black,
//   )),
//   ),
//   )
//   ここまでwidget

//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 1
//       ..style = PaintingStyle.fill;
//     const double triangleH = 10;
//     const double triangleW = 20.0;
//     final double width = size.width;
//     final double height = size.height;
//
//     final Path trianglePath = Path()
//       ..moveTo(width / 2 - triangleW / 5, height)
//       ..lineTo(width / 2, triangleH + height)
//       ..lineTo(width / 2 + triangleW / 2, height)
//       ..lineTo(width / 2 - triangleW / 2, height);
//     canvas.drawPath(trianglePath, paint);
//     final BorderRadius borderRadius = BorderRadius.circular(15);
//     final Rect rect = Rect.fromLTRB(0, 0, width, height);
//     final RRect outer = borderRadius.toRRect(rect);
//     canvas.drawRRect(outer, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

