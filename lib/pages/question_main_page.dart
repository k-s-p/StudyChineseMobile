import 'package:flutter/material.dart';
import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/repository/category_repository.dart';

class QuestionMainPage extends StatefulWidget {
  final String questionType;

  const QuestionMainPage({required this.questionType});

  @override
  State<QuestionMainPage> createState() => _QuestionMainPageState();
}

class _QuestionMainPageState extends State<QuestionMainPage> {
  final CategoryRepository categoryRepository = CategoryRepository();
  List<Category> categoryList = List.empty();
  int? isCategory;
  int isQuestionNum = 10;
  int isHani = 1;

  @override
  void initState() {
    Future(() async {
      await categoryRepository.getCategoryList().then((value) {
        setState(() {
          categoryList = value;
          isCategory = categoryList.reduce((curr, next) => curr.id < next.id ? curr : next).id;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('問題設定'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.questionType,
              style: const TextStyle(fontSize: 45),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("カテゴリ"),
                DropdownButton(
                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    items: categoryList
                        .map<DropdownMenuItem<int>>((Category category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                    value: isCategory,
                    onChanged: (int? value) {
                      setState(
                        () {
                          isCategory = value!;
                        },
                      );
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("問題数"),
                DropdownButton(
                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 10,
                        child: Text("10"),
                      ),
                      DropdownMenuItem(
                        value: 15,
                        child: Text("15"),
                      ),
                      DropdownMenuItem(
                        value: 20,
                        child: Text("20"),
                      ),
                      DropdownMenuItem(
                        value: 30,
                        child: Text("30"),
                      ),
                      DropdownMenuItem(
                        value: 50,
                        child: Text("50"),
                      ),
                      DropdownMenuItem(
                        value: 100,
                        child: Text("100"),
                      ),
                    ],
                    value: isQuestionNum,
                    onChanged: (int? value) {
                      setState(
                        () {
                          isQuestionNum = value!;
                        },
                      );
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("出題範囲"),
                DropdownButton(
                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text("未学習"),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text("すべて"),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text("1日以上前"),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Text("1週間以上前"),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Text("1カ月以上前"),
                      ),
                    ],
                    value: isHani,
                    onChanged: (int? value) {
                      setState(
                        () {
                          isHani = value!;
                        },
                      );
                    })
              ],
            ),
            ElevatedButton(
              child: const Text("スタート！！"),
              onPressed: () {
                //
              },
            )
          ],
        ));
  }
}
