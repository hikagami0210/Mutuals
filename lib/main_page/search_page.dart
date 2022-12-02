import 'package:flutter/material.dart';

import '../sub_page/posting_page.dart';
import 'Homepage/get_post_model.dart';
import 'Homepage/post_card.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {



  @override
  void initState() {
    super.initState();
    print("load");
  }
  bool _isLoading = false;


  List<Post> _allPosts =[];

  // final String _uid = FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗';
  // final String _email = FirebaseAuth.instance.currentUser?.email.toString() ?? 'ログインユーザーemail取得失敗';
  Future _fetchAllPosts()async {
    print("start");
    print(_isLoading);
    if(_isLoading == false) {
      List<Post> fetchAllPosts = await FirebaseService.fetchAllPosts();
      setState(() {
        _allPosts = fetchAllPosts;
        _isLoading = true;
      });
      print(_allPosts.length);
      print("complete");
    }else{print("error");}
    return _fetchAllPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const PostingPage();
          }));setState(() {
            _isLoading = false;
          });
          _fetchAllPosts();
        },
        child: const Icon(Icons.add, size: 40),
      ),

      body: Center(
        child: Column(
          children: [

            Flexible(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = false;
                    });
                    await _fetchAllPosts();
                  },
                  child: FutureBuilder(
                      future: _fetchAllPosts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        switch(_isLoading) {
                          case false:
                            return const CircularProgressIndicator();
                          case true:
                            return ListView.builder(
                              itemCount: _allPosts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PostCard(text: _allPosts[index].text,
                                    tags: _allPosts[index].tags,
                                    createdAt: _allPosts[index].createdAt,
                                    postUserId: _allPosts[index].postUserId,
                                    likesCount: _allPosts[index].likesCount,
                                    imageURL: _allPosts[index].imageURL,
                                    postID: _allPosts[index].postID,
                                    index: index);
                              },
                            );
                          default:
                            return const CircularProgressIndicator();
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
