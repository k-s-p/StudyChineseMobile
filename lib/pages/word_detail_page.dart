import 'package:flutter/material.dart';

class WordDetailPage extends StatefulWidget {
  final String pinyin;
  final String word;
  final String meaning;

  WordDetailPage({required this.pinyin, required this.word, required this.meaning});

  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  List<String> sentences = ["テスト例文１", "テスト例文2"];

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
            style: const TextStyle(fontSize: 15),
          ),
          Text(kanjiList[i],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
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
        title: const Text('単語詳細'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: makeWordColumnList(widget.word, widget.pinyin),
          ),
          Text('意味: ${widget.meaning}'),
          Expanded(child: ListView.builder(
            itemCount: sentences.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(sentences[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      sentences.removeAt(index);
                    });
                  },
                ),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            sentences.add("");
          });
        },
      ),
    );
  }
}
