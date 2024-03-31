import 'package:flutter/material.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/pages/word_detail_page.dart';

final dummyData = [
  WordData(
      id: 1,
      category: 'HSK1',
      word: '哎',
      pinyin: 'ai',
      meaning: 'テスト',
      exampleSentences: ['あいや～とぶぴはよく言う', 'なんかかわいいな']),
  WordData(
      id: 2,
      category: 'HSK2',
      word: 'テスト',
      pinyin: 'te su to',
      meaning: 'テストです'),
  WordData(
      id: 3, category: 'HSK3', word: '菅谷', pinyin: 'suga ya', meaning: 'すがや'),
  WordData(
      id: 4,
      category: 'HSK4',
      word: 'あいうえお',
      pinyin: 'a i u e o',
      meaning:
          'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
      exampleSentences: ['あいうえおかきくけこ', 'たのしいな～']),
];

class WordListPage extends StatelessWidget {
  const WordListPage({super.key});

  // データベースからのデータ取得は非同期処理
  Future<List<WordData>> fetchWords() async {
    // TODO: データベースからデータ取得
    return dummyData;
  }

  // 単語一文字の上にピンインを置いたContainerのリストを返す
  List<Container> makeWordColumnList(String word, String pinyin) {
    List<Container> wordColumnList = [];
    var kanjiList = word.split('');
    var pinyinList = pinyin.split(' ');
    for (int i = 0; i < pinyinList.length; i++) {
      var wordColumn = Container(
        padding: const EdgeInsets.only(left: 1.5),
        child: Column(children: [
          Text(
            pinyinList[i],
            style: const TextStyle(fontSize: 12),
          ),
          Text(kanjiList[i],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
        ]),
      );
      wordColumnList.add(wordColumn);
    }
    return wordColumnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語学習'),
      ),
      body: FutureBuilder<List<WordData>>(
        future: fetchWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('エラー: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var wordData = snapshot.data![index];
                // リストの要素を作成
                return Container(
                  decoration:
                      const BoxDecoration(border: Border(bottom: BorderSide())),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                    onTap: () {
                      // タップで詳細画面へ遷移
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => WordDetailPage(
                              id: wordData.id,))));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          makeWordColumnList(wordData.word, wordData.pinyin),
                    ),
                    subtitle: Text(
                      wordData.meaning,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () {
                        // TODO: 音声出力機能作成予定
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
