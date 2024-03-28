import 'package:flutter/material.dart';

class WordDetailPage extends StatefulWidget {
  final String pinyin;
  final String word;
  final String meaning;

  WordDetailPage(
      {required this.pinyin, required this.word, required this.meaning});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語詳細'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // 前の単語に移動
                },
              ),
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // 次の単語に移動
                },
              )
            ],
          ),
          // 単語
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: makeWordColumnList(widget.word, widget.pinyin),
          ),
          // 意味
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text('意味: ${widget.meaning}'),
          ),
          // 例文
          Expanded(
            child: ListView.builder(
            itemCount: sentences.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: TextFormField(
                  initialValue: sentences[index],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 5)),
                  onChanged: (value) {
                    setState(() {
                      sentences[index] = value;
                    });
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
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
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            sentences.add("");
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: const Text("例文保存"),
          onPressed: () {
            // DBに保存する
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("例文を保存しました"), duration: Duration(seconds: 2),));
          },
        ),
      ),
    );
  }
}
