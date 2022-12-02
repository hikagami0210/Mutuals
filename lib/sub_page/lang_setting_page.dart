import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_fun/main.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';



class lang extends ConsumerWidget {
  const lang({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lang)
      ),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.japanese),
              onPressed: (context) async{
                final prefs = await SharedPreferences.getInstance();
                ref.read(langProvider.notifier).state = 'ja';
                prefs.setString('setLang','ja');
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.english),
              onPressed: (context) async{
                final prefs = await SharedPreferences.getInstance();
                ref.read(langProvider.notifier).state = 'en';
                prefs.setString('setLang', 'en');
              },
            ),
          ],)
        ],
      ),
    );
  }
}
