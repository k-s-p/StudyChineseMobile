import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/pages/word_detail_page.dart';
import 'package:study_chinese/repository/category_repository.dart';
import 'package:study_chinese/repository/word_repository.dart';
import 'package:study_chinese/utils/text_to_speech_util.dart';

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

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  final wordRepository = WordRepository();
  final categoryRepository = CategoryRepository();
  final textToSpeechUtil = TextToSpeechUtil();

  List<Word> _wordList = List.empty();
  List<Word> _searchedwordList = List.empty();
  List<Category> _categorySelectList = List.empty();
  int? isSelectedItem;
  String? isSearchStr;

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

  // 単語検索機能
  List<Word> searchWordList(List<Word> wordList, String? target) {
    if (target == null || target.isEmpty) {
      return wordList;
    } else {
      return wordList.where((element) {
        return element.word.contains(target);
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    // _wordList = Future(() async {
    //   return wordRepository.getWordList(1);
    // });
    categoryRepository.getCategoryList().then((value) {
      setState(() {
        _categorySelectList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語学習'),
      ),
      body: Column(children: [
        TextField(
          decoration: InputDecoration(labelText: "検索"),
          onSubmitted: (value) {
            // 検索処理
            setState(() {
              isSearchStr = value;
              _searchedwordList = searchWordList(_wordList, value);
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButton<int>(
          hint: const Text("カテゴリ選択"),
          itemHeight: 50,
          isDense: false,
          isExpanded: true,
          underline: Container(
            height: 1,
            color: Colors.black,
          ),
          items: _categorySelectList
              .map<DropdownMenuItem<int>>((Category category) {
            return DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.categoryName),
            );
          }).toList(),
          value: isSelectedItem,
          onChanged: (value) {
            // カテゴリを選択したら、DBから単語リストを取得する
            setState(() {
              isSelectedItem = value;
            });
            wordRepository.getWordList(value ?? 0).then((result) {
              setState(() {
                _wordList = result;
                _searchedwordList = searchWordList(_wordList, isSearchStr);
              });
            });
          },
        ),
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchedwordList.length,
            itemBuilder: (context, index) {
              var wordData = _searchedwordList[index];
              // リストの要素を作成
              return Container(
                decoration:
                    const BoxDecoration(border: Border(bottom: BorderSide())),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  onTap: () {
                    // タップで詳細画面へ遷移
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => WordDetailPage(
                              id: wordData.id,
                            ))));
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
                      // TODO: 音声出力機能
                      textToSpeechUtil.speak(wordData.word);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
