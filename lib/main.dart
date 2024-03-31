import 'package:flutter/material.dart';
import 'package:study_chinese/pages/main_page.dart';
import 'package:study_chinese/utils/database_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初期データの作成を行う
  final db = await DataBaseUtil().initializeDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中国語学習アプリ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF55C500),
        ),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black)
      ),
      home: const MainPage(title: '中国語学習アプリ')
    );
  }
}
