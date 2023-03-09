import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_fun/main_page/search_page.dart';
import 'package:music_fun/main_page/thread_page.dart';
import 'Homepage/home_page.dart';
import 'my_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.home);

enum ViewType { home, search, thread, myPage }

class BaseTabView extends ConsumerWidget {
  BaseTabView({Key? key}) : super(key: key);

  final widgets = [
    const HomePageView(),
    const SearchPage(),
    const ThreadPage(),
    const myPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(baseTabViewProvider.state);
    return Scaffold(
      // appBar: AppBar(title: Text(""),automaticallyImplyLeading: false,centerTitle: true,),widgets[view.state.index]
      body: IndexedStack(index: view.state.index,
          children: [
            widgets[0],
            widgets[1],
            widgets[2],
            widgets[3],
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.homePageTitle),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "All Posts"),
          BottomNavigationBarItem(icon: const Icon(Icons.book), label: AppLocalizations.of(context)!.threadPageTitle),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppLocalizations.of(context)!.myPageTitle),
        ],
        currentIndex: view.state.index,
        onTap: (int index) => view.update((state) => ViewType.values[index]),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

