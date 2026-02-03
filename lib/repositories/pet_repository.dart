import '../models/pet_model.dart';
import '../settings/database_connection.dart';

class MascotaRepository {
  final String tableName = 'mascota';
  final database = DatabaseConnection();

  // Insertar mascota
  Future<int> create(MascotaModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // Editar mascota
  Future<int> edit(MascotaModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // Eliminar mascota
  Future<int> delete(int mascId) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [mascId]);
  }

  // Listar todas las mascotas
  Future<List<MascotaModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => MascotaModel.fromMap(e)).toList();
  }

  // Obtener mascota por ID
  /*
  Future<MascotaModel?> getById(int mascId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'masc_id = ?',
      whereArgs: [mascId],
      limit: 1,
    );

    if (response.isNotEmpty) {
      return MascotaModel.fromMap(response.first);
    }
    return null;
  }

  // Obtener mascotas por Dueño
  Future<List<MascotaModel>> getByDueno(int dueId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'due_id = ?',
      whereArgs: [dueId],
    );

    return response.map((e) => MascotaModel.fromMap(e)).toList();
  }*/

  Future<bool> nombreUnico(String nombre, int dueId) async {
    final db = await database.db;
    final result = await db.query(
      'mascota',
      where: 'nombre = ? AND due_id  = ?',
      whereArgs: [nombre, dueId],
    );
    return result.isEmpty;
  }

  Future<bool> nombreUnicoEditar(String nombre, int dueId, int mascId) async {
    final db = await database.db;
    final result = await db.query(
      'mascota',
      where:
          'nombre = ? AND due_id = ? AND id != ?',  
      whereArgs: [nombre, dueId, mascId],
    );

    return result.isEmpty; 
  }
}
