import 'package:flutter/material.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/repository/word_repository.dart';

class WordDetailPage extends StatefulWidget {
  final int id;

  WordDetailPage({required this.id});

  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  late Future<Map<String, dynamic>> _word_and_sentences;
  final wordRepository = WordRepository();
  List<String> exampleSentenceList = [];
  int wordId = -1;
  String studyWord = "";

  List<Container> makeWordColumnList(String word, String pinyin) {
    List<Container> wordColumnList = [];
    var kanjiList = word.split('');
    var pinyinList = pinyin.split(' ');
    for (var i = 0; i < pinyinList.length; i++) {
      var wordColumn = Container(
        padding: const EdgeInsets.only(left: 1.5),
        child: Column(children: [
          Text(
            pinyinList[i],
            style: const TextStyle(fontSize: 25),
          ),
          Text(kanjiList[i],
              style: const TextStyle(
                  fontSize: 50, fontWeight: FontWeight.bold, height: 1.0))
        ]),
      );
      wordColumnList.add(wordColumn);
    }
    return wordColumnList;
  }

  @override
  void initState() {
    super.initState();
    _word_and_sentences = Future(() async {
      return wordRepository.getWordAndSentences(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語詳細'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _word_and_sentences,
          builder: (context, snapshot) {
            // 結果取得
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('エラー: ${snapshot.error}');
            } else {
              Word word = snapshot.data!["word"];
              List<ExampleSentence> sentences = snapshot.data!["sentences"];
              if (wordId == -1) {
                wordId = word.id;
                studyWord = word.word;
                exampleSentenceList = sentences.map((s) => s.sentence).toList();
              }
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          // 前の単語に移動
                          setState(() {
                            exampleSentenceList.clear();
                            wordId = -1;
                            studyWord = "";
                            _word_and_sentences =
                                wordRepository.getPreWordAndSentences(
                                    word.id, word.category.id);
                          });
                        },
                      ),
                      Text(
                        word.category.categoryName,
                        style:
                            const TextStyle(fontSize: 40, color: Colors.blue),
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          // 次の単語に移動
                          setState(() {
                            exampleSentenceList.clear();
                            wordId = -1;
                            studyWord = "";
                            _word_and_sentences =
                                wordRepository.getNextWordAndSentences(
                                    word.id, word.category.id);
                          });
                        },
                      )
                    ],
                  ),
                  // 単語
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: makeWordColumnList(word.word, word.pinyin),
                  ),
                  // 意味
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text('意味: ${word.meaning}'),
                  ),
                  // 例文
                  const Text(
                    "例文",
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: exampleSentenceList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == exampleSentenceList.length) {
                        return ListTile(
                            title: IconButton(
                          icon: Icon(Icons.add_circle),
                          iconSize: 30,
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              exampleSentenceList.add("");
                            });
                          },
                        ));
                      } else {
                        return ListTile(
                          title: TextField(
                            controller: TextEditingController(
                                text: exampleSentenceList[index]),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 5)),
                            style: TextStyle(
                              color:
                                  exampleSentenceList[index].contains(word.word)
                                      ? Colors.black
                                      : Colors.red,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                exampleSentenceList[index] = value;
                              });
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                exampleSentenceList.removeAt(index);
                              });
                            },
                          ),
                        );
                      }
                    },
                  )),
                ],
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: const Text("例文保存"),
          onPressed: () async {
            // DBに保存する
            if (await wordRepository.storeExampleSentences(
                wordId, exampleSentenceList, studyWord)) {
              // snackを表示する
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("例文を保存しました"),
                duration: Duration(seconds: 2),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("例文の保存に失敗しました"),
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
      ),
    );
  }
}
