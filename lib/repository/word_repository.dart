import 'dart:math';

import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/utils/database_util.dart';

class WordRepository {
  
  // DBから単語データを取得
  Future<Word> getWordData(int id) async {
    final db = await DataBaseUtil().initializeDatabase();
    // List<Map<String, dynamic>> data = await db.query('word', where: 'id = ?', whereArgs: [id]);
    List<Map<String, dynamic>> data = await db.rawQuery(
        'select word.id, word, pinyin, meaning, category_id, category_name from word inner join category on category.id = word.category_id where word.id = $id');
    return Word.fromMap(data.first);
  }

  // 次単語ボタンで同カテゴリの次の単語を取得する
  Future<Word> getNextWordData(int id, int categoryId) async {
    final db = await DataBaseUtil().initializeDatabase();

    List<Map<String, dynamic>> data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          and
            word.id > $id
          order by word.id
          limit 1 ;
          """);
    if (data.isEmpty) {
      // 空なら先頭に戻る
      data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          order by word.id
          limit 1 ;
          """);
    }
    return Word.fromMap(data.first);
  }

  // 前単語ボタンで同カテゴリの次の単語を取得する
  Future<Word> getPreWordData(int id, int categoryId) async {
    final db = await DataBaseUtil().initializeDatabase();

    List<Map<String, dynamic>> data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          and
            word.id < $id
          order by word.id desc
          limit 1 ;
          """);
    if (data.isEmpty) {
      // 空なら最後尾に戻る
      data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          order by word.id desc
          limit 1 ;
          """);
    }
    return Word.fromMap(data.first);
  }

  // word_idから例文リストを取得
  Future<List<ExampleSentence>> getExampleSentences(int wordId) async {
    final db = await DataBaseUtil().initializeDatabase();
    List<Map<String, dynamic>> data = await db.rawQuery("""
        select id, word_id, example_sentence
        from example_sentence
        where word_id = $wordId
        order by id;
      """);

    return List.generate(
        data.length, (index) => ExampleSentence.fromMap(data[index]));
  }

  // 単語idから単語と例文のFutureを返す
  Future<Map<String, dynamic>> getWordAndSentences(int id) async {
    Word word = await getWordData(id);
    List<ExampleSentence> sentences = await getExampleSentences(word.id);
    return {'word': word, 'sentences': sentences};
  }

  // 単語idとカテゴリidから次の単語と例文のFutureを返す
  Future<Map<String, dynamic>> getNextWordAndSentences(
      int id, int categoryId) async {
    Word word = await getNextWordData(id, categoryId);
    List<ExampleSentence> sentences = await getExampleSentences(word.id);
    return {'word': word, 'sentences': sentences};
  }

  // 単語idとカテゴリidから前の単語と例文のFutureを返す
  Future<Map<String, dynamic>> getPreWordAndSentences(
      int id, int categoryId) async {
    Word word = await getPreWordData(id, categoryId);
    List<ExampleSentence> sentences = await getExampleSentences(word.id);
    return {'word': word, 'sentences': sentences};
  }

  // 例文を保存する
  Future<bool> storeExampleSentences(
      int wordId, List<String> exampleSentenceList, String word) async {
    final db = await DataBaseUtil().initializeDatabase();

    try {
      await db.transaction((txn) async {
        await txn.delete('example_sentence',
            where: "word_id = ?", whereArgs: [wordId]);

        for (var sentence in exampleSentenceList) {
          if (!sentence.contains(word)) {
            throw Exception('単語が含まれない例文があります');
          }
          await txn.insert('example_sentence',
              {'word_id': wordId, 'example_sentence': sentence});
        }
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  // categoryidから単語のリストを取得する
  Future<List<Word>> getWordList(int categoryId) async {
    final db = await DataBaseUtil().initializeDatabase();

    List<Map<String, dynamic>> data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          order by word.id;
          """);

    return List.generate(
        data.length, (index) => Word.fromMap(data[index]));
  }

  // 問題として出力する単語とその回答候補を取得する
  Future<List<List<Word>>> getFourSelectQuestionMap(int categoryId, int questionNum) async {
    final db = await DataBaseUtil().initializeDatabase();

    List<Map<String, dynamic>> data = await db.rawQuery("""
          select 
            word.id, 
            word, 
            pinyin, 
            meaning, 
            category_id, 
            category_name 
          from 
              word 
          inner join 
              category 
          on category.id = word.category_id 
          where
            word.category_id = $categoryId 
          order by word.id
          """);

    List<Word> wordList = List.generate(data.length, (index) => Word.fromMap(data[index]));

    // questionNum数の問題単語と、その4択選択肢3つを用意する
    List<List<Word>> questionList = <List<Word>>[];
    var random = Random();
    for (var word in wordList) {
      if(questionNum == 0) break;
      questionList.add([word]);
      while(questionList.last.length < 4){
        var temp = wordList[random.nextInt(wordList.length)];
        if(questionList.last.contains(temp)) continue;
        questionList.last.add(temp);
      }
      questionNum--;
    }

    return questionList;
  }
}
