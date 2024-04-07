import 'package:flutter/services.dart' show rootBundle;
import 'package:study_chinese/models/word.dart';

class CsvImportUtil {

  Future<List<Word>> getSqliteInitDataCsv(String path) async {
    List<Word> wordList = [];

    // assetsからDBの初期データ取得
    final String csvData = await rootBundle.loadString(path);

    // csvをWordクラスに変換
    int categoryId = 0;
    String nowCategory = "";
    for (String line in csvData.split("\n")){
      if (wordList.length + 1 == csvData.split("\n").length) break;
      List rows = line.split(",");
      if (rows[0] == "カテゴリ") continue;
      if (nowCategory != rows[0]){
        nowCategory = rows[0];
        categoryId++;
      }
      // print(rows);
      wordList.add(Word(id: wordList.length + 1, category: Category(id: categoryId, categoryName: nowCategory), word: rows[1], pinyin: rows[2], meaning: rows[3]));
    }

    return wordList;
  }
}