import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/repository/word_repository.dart';

class QuestionAnswerPage extends StatefulWidget {
  final String questionType;
  final int isCategory;
  final int isQuestionNum;
  final int isHani;

  const QuestionAnswerPage(
      {required this.questionType,
      required this.isCategory,
      required this.isQuestionNum,
      required this.isHani});

  @override
  State<QuestionAnswerPage> createState() => __QuestionAnswerPageState();
}

class __QuestionAnswerPageState extends State<QuestionAnswerPage> {
  int questionIndex = 0;
  late Future<List<List<Word>>> _questionList;

  // タイマー
  late Timer _timer;
  final ValueNotifier<double> _progress = ValueNotifier(0);

  final wordRepository = WordRepository();

  String convertPinyinToneMarks(String s) {
    s = s.toLowerCase();
    s = s.replaceAll('v', 'ü');
    List<String> pinyinList = s.split(' ');
    for (int i = 0; i < pinyinList.length; i++) {
      String res = '';
      String seicho = pinyinList[i][pinyinList[i].length - 1];
      String pinyin = pinyinList[i].substring(0, pinyinList[i].length - 1);
      if (!['1', '2', '3', '4', '5'].contains(seicho)) {
        seicho = '';
        pinyin = pinyinList[i];
      }

      if (pinyin.contains('a')) {
        res = pinyin.replaceAll('a', 'a$seicho');
      } else if (pinyin.contains('e')) {
        res = pinyin.replaceAll('e', 'e$seicho');
      } else if (pinyin.contains('o')) {
        res = pinyin.replaceAll('o', 'o$seicho');
      } else if (pinyin.contains('iu')) {
        res = pinyin.replaceAll('iu', 'iu$seicho');
      } else if (pinyin.contains('ui')) {
        res = pinyin.replaceAll('ui', 'ui$seicho');
      } else if (pinyin.contains('i')) {
        res = pinyin.replaceAll('i', 'i$seicho');
      } else {
        res = pinyin.replaceAll('u', 'u$seicho');
      }

      pinyinList[i] = res;
    }

    s = pinyinList.join(' ');
    s = s.replaceAll('1', '̄');
    s = s.replaceAll('2', '́');
    s = s.replaceAll('3', '̌');
    s = s.replaceAll('4', '̀');
    s = s.replaceAll('5', '');
    return s;
  }

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
    _questionList = Future(() {
      return wordRepository.getFourSelectQuestionMap(
          widget.isCategory, widget.isQuestionNum);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questionType),
      ),
      body: FutureBuilder(
          future: _questionList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('エラー: ${snapshot.error}');
            } else {
              if (questionIndex == snapshot.data!.length) {
                questionIndex = 0;
              }
              var question = snapshot.data![questionIndex];
              var correct = question.first;
              question.shuffle();

              _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
                _progress.value += 0.01;
                if (_progress.value >= 1) {
                  _timer.cancel();
                }
              });

              return Column(
                children: <Widget>[
                  ValueListenableBuilder(
                      valueListenable: _progress,
                      builder: (context, value, child) {
                        return SizedBox(
                          height: 30,
                          child: LinearProgressIndicator(
                            value: value,
                          ),
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: makeWordColumnList(
                        correct.word, convertPinyinToneMarks(correct.pinyin)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(300, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(),
                          ),
                          onPressed: () {
                            setState(() {
                              questionIndex++;
                            });
                          },
                          child: Text(
                            question[0].meaning,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(300, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(),
                          ),
                          onPressed: () {
                            setState(() {
                              questionIndex++;
                            });
                          },
                          child: Text(
                            question[1].meaning,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(300, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(),
                          ),
                          onPressed: () {
                            setState(() {
                              questionIndex++;
                            });
                          },
                          child: Text(
                            question[2].meaning,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(300, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(),
                          ),
                          onPressed: () {
                            setState(() {
                              questionIndex++;
                            });
                          },
                          child: Text(
                            question[3].meaning,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
