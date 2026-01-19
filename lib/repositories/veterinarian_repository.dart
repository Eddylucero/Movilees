import '../models/veterinarian_model.dart';
import '../settings/database_connection.dart';

class VeterinarioRepository {
  final String tableName = 'veterinario';
  final DatabaseConnection database = DatabaseConnection();

  // Insertar veterinario
  Future<int> create(VeterinarioModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // Editar veterinario
  Future<int> edit(VeterinarioModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'vet_id = ?',
      whereArgs: [data.vetId],
    );
  }

  // Eliminar veterinario
  Future<int> delete(int vetId) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'vet_id = ?', whereArgs: [vetId]);
  }

  // Listar todos los veterinarios
  Future<List<VeterinarioModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => VeterinarioModel.fromMap(e)).toList();
  }

  // Obtener veterinario por ID
  Future<VeterinarioModel?> getById(int vetId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'vet_id = ?',
      whereArgs: [vetId],
      limit: 1,
    );

    if (response.isNotEmpty) {
      return VeterinarioModel.fromMap(response.first);
    }
    return null;
  }
}
