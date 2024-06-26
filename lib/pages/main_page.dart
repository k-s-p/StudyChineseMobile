import 'package:flutter/material.dart';
import 'package:study_chinese/pages/question_main_page.dart';
import 'package:study_chinese/pages/word_list_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: 200,
              height: 100,
              child: ElevatedButton(
              child: const Text('単語学習', style: TextStyle(fontSize: 20),),
              onPressed: () {
                // TODO: 単語学習画面へ遷移処理
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => const WordListPage())
                  )
                );
              },
            )),
            Container(
              padding: const EdgeInsets.all(8),
              width: 200,
              height: 100,
              child: ElevatedButton(
                  child: const Text('テスト', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    // テストを選択させる
                    showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('どのテストに挑戦しますか？'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text('意味四択'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuestionMainPage(questionType: "意味四択")));
                    },
                  ),
                  ListTile(
                    title: const Text('単語四択'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuestionMainPage(questionType: "単語四択")));
                    },
                  ),
                  ListTile(
                    title: const Text('ピンイン入力'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuestionMainPage(questionType: "ピンイン入力",)));
                    },
                  ),
                  ListTile(
                    title: const Text('例文穴埋め'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuestionMainPage(questionType: "例文穴埋め",)));
                    },
                  ),
                ],
              ),
            );
          },
        );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.import_export),
                  onPressed: () {
                    // TODO CSVインポート機能
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO 設定画面へ遷移
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.pie_chart),
                  onPressed: () {
                    // TODO　進捗状況画面へ遷移
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
