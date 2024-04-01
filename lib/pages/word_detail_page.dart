import 'package:flutter/material.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/repository/word_repository.dart';

class WordDetailPage extends StatefulWidget {
  final int id;
  // final String pinyin;
  // final String word;
  // final String meaning;

  WordDetailPage({required this.id});

  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  late Future<Map<String, dynamic>> _word_and_sentences;
  List<String> exampleSentenceList = [];
  int wordId = -1;

  List<Container> makeWordColumnList(String word, String pinyin) {
    List<Container> wordColumnList = [];
    var kanjiList = word.split('');
    var pinyinList = pinyin.split(' ');
    for(var i = 0; i < pinyinList.length; i++) {
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
      return WordRepository().getWordAndSentences(widget.id);
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
              if(exampleSentenceList.isEmpty){
                wordId = word.id;
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
                            _word_and_sentences = WordRepository().getPreWordAndSentences(word.id, word.category.id);
                          });
                        },
                      ),
                      Text(word.category.categoryName, style: const TextStyle(fontSize: 40, color: Colors.blue),),
                      IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          // 次の単語に移動
                          setState(() {
                            exampleSentenceList.clear();
                            _word_and_sentences = WordRepository().getNextWordAndSentences(word.id, word.category.id);
                          });
                        },
                      )
                    ],
                  ),
                  // 単語
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: makeWordColumnList(
                        word.word, word.pinyin),
                  ),
                  // 意味
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text('意味: ${word.meaning}'),
                  ),
                  // 例文
                  const Text("例文"),
                  Expanded(
                      child: ListView.builder(
                    itemCount: exampleSentenceList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextFormField(
                          initialValue: exampleSentenceList[index],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 5)),
                          onChanged: (value) {
                            exampleSentenceList[index] = value;
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
                    },
                  )),
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            exampleSentenceList.add("");
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: const Text("例文保存"),
          onPressed: () async {
            // DBに保存する
            await WordRepository().storeExampleSentences(wordId, exampleSentenceList);

            // snackを表示する
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("例文を保存しました"),
              duration: Duration(seconds: 2),
            ));
          },
        ),
      ),
    );
  }
}
