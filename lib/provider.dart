import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page/main_page_navi.dart';

//言語設定デフォ値

// StateProvider<Locale> langProvider = StateProvider((ref) => Locale('ja'));

//テーマカラー デフォ値
// StateProvider themeModeProvider    = StateProvider((ref) => ThemeData(primaryColor: Colors.blue));

//アプリ初回起動時の言語設定デフォ値
StateProvider langSetupProvider    = StateProvider((ref) => "Japanese");

//uuid
Provider<String> uuid = Provider((ref) => FirebaseAuth.instance.currentUser?.uid.toString() ?? 'ログインユーザーid取得失敗');


