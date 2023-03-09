import 'package:flutter/material.dart';

class Futu extends StatefulWidget {
  const Futu({Key? key}) : super(key: key);

  @override
  State<Futu> createState() => _FutuState();
}

class _FutuState extends State<Futu> {

  Future<dynamic>? _data;

  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future? _test(){
    print("じっこう");
    _data = Future.delayed(const Duration(seconds: 2), () => '再度完了');
    setState(() {});
    return _data;
  }

  @override
  initState() {
    super.initState();
    // ②Futureをあらかじめ_dataに保持しておく
    _test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // ③FutureBuilderに_dataを渡す
        future: _data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              String data = snapshot.data;
              return contents(data);
            } else {
              String data = 'エラー';
              return contents(data);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text('$_counter', style: const TextStyle(fontSize: 24)),
                ],
              ),
            );
          } else {
            String data = 'エラー';
            return contents(data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Center contents(String data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data, style: const TextStyle(fontSize: 24)),
          Text('$_counter', style: const TextStyle(fontSize: 24)),
          ElevatedButton(onPressed: (){
            _test();
          }, child: Text("もっかいはしらせる")),
        ],
      ),
    );
  }
}
