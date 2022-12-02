import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../provider.dart';

class theme extends ConsumerWidget {
  const theme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(
      appBar: AppBar(title: Text("テーマカラー"),),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: const Text('ライトテーマ'),
              leading: Icon(Icons.color_lens_outlined),
              onPressed: (context)async{
                final prefs = await SharedPreferences.getInstance();
                ref.read(themeProvider.notifier).state = ThemeData(primaryColor: Colors.blue);
                prefs.setString('setTheme','light');
              },
            ),
            SettingsTile(
              title: Text('ダークテーマ'),
              leading: Icon(Icons.palette_outlined),
              onPressed: (context)async{
                final prefs = await SharedPreferences.getInstance();
                ref.read(themeProvider.notifier).state = ThemeData.dark();
                prefs.setString('setTheme','dark');
                },
            ),
          ],)
        ],
      ),
    );
  }
}


