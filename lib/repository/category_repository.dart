import 'package:study_chinese/models/word.dart';
import 'package:study_chinese/utils/database_util.dart';

class CategoryRepository {

  // DBからカテゴリのリストを取得
  Future<List<Category>> getCategoryList() async {
    final db = await DataBaseUtil().initializeDatabase();

    List<Map<String, dynamic>> data = await db.rawQuery("""
          select 
            id, 
            category_name 
          from 
            category 
          order by id;
          """);

    return List.generate(
        data.length, (index) => Category.fromMap(data[index]));
  }
}