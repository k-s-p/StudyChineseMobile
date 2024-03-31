import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/utils/database_util.dart';

class WordRepository {

  // DBから単語データを取得
  Future<Word> getWordData(int id) async {

    final db = await DataBaseUtil().initializeDatabase();
    List<Map<String, dynamic>> data = await db.query('word', where: 'id = ?', whereArgs: [id]);
    return Word.fromMap(data.first);
  }  
}