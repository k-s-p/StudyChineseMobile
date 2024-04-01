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

    List<Map<String, dynamic>> data = await db.rawQuery(
        """
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
    if(data.isEmpty){
      // 空なら先頭に戻る
      data = await db.rawQuery(
        """
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

    List<Map<String, dynamic>> data = await db.rawQuery(
        """
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
    if(data.isEmpty){
      // 空なら最後尾に戻る
      data = await db.rawQuery(
        """
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
    List<Map<String, dynamic>> data = await db.rawQuery(
      """
        select id, word_id, example_sentence
        from example_sentence
        where word_id = $wordId
        order by id;
      """);

    return List.generate(data.length, (index) => ExampleSentence.fromMap(data[index]));
  }

  Future<Map<String, dynamic>> getWordAndSentences(int id) async {
  Word word = await getWordData(id);
  List<ExampleSentence> sentences = await getExampleSentences(word.id);
  return {'word': word, 'sentences': sentences};
}

  Future<Map<String, dynamic>> getNextWordAndSentences(int id, int categoryId) async {
    Word word = await getNextWordData(id, categoryId);
    List<ExampleSentence> sentences = await getExampleSentences(word.id);
    return {'word': word, 'sentences': sentences};
  }

  Future<Map<String, dynamic>> getPreWordAndSentences(int id, int categoryId) async {
    Word word = await getPreWordData(id, categoryId);
    List<ExampleSentence> sentences = await getExampleSentences(word.id);
    return {'word': word, 'sentences': sentences};
  }

  Future<bool> storeExampleSentences(int wordId, List<String> exampleSentenceList) async {
    final db = await DataBaseUtil().initializeDatabase();

    await db.delete('example_sentence', where: "word_id = ?", whereArgs: [wordId]);

    for (var sentence in exampleSentenceList) {
      await db.insert('example_sentence', {
        'word_id': wordId,
        'example_sentence': sentence
      });
    }

    return true;
  }
}
