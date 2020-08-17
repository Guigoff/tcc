import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcc/cartao.dart';

class CartaoHelper {
  static final CartaoHelper _instance = CartaoHelper.internal();

  factory CartaoHelper() => _instance;

  CartaoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }
  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "card_database.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async { 
      await db.execute("CREATE TABLE cartao("
          "id INTEGER PRIMARY KEY, "
          "nome TEXT, "
          "endereco TEXT, "
          "telefone TEXT, "
		      "site TEXT, "
          "observacao TEXT)");
    });
  }

  Future<int> getCount() async {
    Database database = await db;
    return Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM cartao"));
  }

  Future close() async {
    Database database = await db;
    database.close();
  }

  Future<Cartao> save(Cartao cartao) async {
    Database database = await db;
    cartao.id = await database.insert('cartao', cartao.toMap());
    return cartao;
  }

  Future<Cartao> getById(int id) async {
    Database database = await db;
    List<Map> maps = await database.query('cartao',
        columns: ['id', 'nome', 'endereco', 'telefone', 'site', 'observacao'],
        where: 'id = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Cartao.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    Database database = await db;
    return await database.delete('cartao', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database database = await db;
    return await database.rawDelete("DELETE * from cartao");
  }

  Future<int> update(Cartao cartao) async {
    Database database = await db;
    return await database
        .update('cartao', cartao.toMap(), where: 'id = ?', whereArgs: [cartao.id]);
  }

  Future<List<Cartao>> getAll() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM cartao");
    List<Cartao> stuffList = listMap.map((x) => Cartao.fromMap(x)).toList();
    return stuffList;
  }
}
