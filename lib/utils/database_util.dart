import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseUtil {
  final _CREATE_WORD_TABLE =
      "CREATE TABLE word(id integer primary key autoincrement, category_id integer, word text, pinyin text, meaning text)";
  final _CREATE_EXAMPLESENTENCE_TABLE =
      "CREATE TABLE example_sentence(id integer primary key autoincrement, word_id integer, example_sentence text)";
  final _CREATE_CATEGORY_TABLE =
      "CREATE TABLE category(id integer primary key autoincrement, category_name text)";

  // DB初期化
  Future<Database> initializeDatabase() async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'study_chinese.db'),
            onCreate: (db, version) async {
              await db.execute(_CREATE_WORD_TABLE);
              await db.execute(_CREATE_CATEGORY_TABLE);
              await db.execute(_CREATE_EXAMPLESENTENCE_TABLE);
              await db.insert('word', {
                'category_id': 1,
                'word': '哎',
                'pinyin': 'ai',
                'meaning': 'なんかしらんけど'
              });
              await db.insert('word',
                  {'category_id': 1, 'word': '人', 'pinyin': 'ren3', 'meaning': 'ひと'});
              await db.insert('category', {'category_name': 'HSK1'});
              await db.insert(
                  'example_sentence', {'word_id': '1', 'example_sentence': "哎呀~"});
              await db.insert(
                  'example_sentence', {'word_id': '1', 'example_sentence': "哎test"});
            }, version: 1);
    return database;
  }

  // DBを作り直したいとき
  Future<void> deleteDatabase() async {
    final path = join(await getDatabasesPath(), 'study_chinese.db');
    await databaseFactory.deleteDatabase(path);
  }
}
