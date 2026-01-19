import '../models/owner_model.dart';
import '../settings/database_connection.dart';

class OwnerRepository {
  final String tableName = 'dueno';
  final DatabaseConnection database = DatabaseConnection();

  // Insertar dueño
  Future<int> create(OwnerModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // Editar dueño
  Future<int> edit(OwnerModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'due_id = ?',
      whereArgs: [data.dueId],
    );
  }

  // Eliminar dueño
  Future<int> delete(int dueId) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'due_id = ?', whereArgs: [dueId]);
  }

  // Listar todos los dueños
  Future<List<OwnerModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => OwnerModel.fromMap(e)).toList();
  }

  // Obtener dueño por ID
  Future<OwnerModel?> getById(int dueId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'due_id = ?',
      whereArgs: [dueId],
      limit: 1,
    );

    if (response.isNotEmpty) {
      return OwnerModel.fromMap(response.first);
    }
    return null;
  }
}
