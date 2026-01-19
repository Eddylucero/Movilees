import '../models/vaccine_model.dart';
import '../settings/database_connection.dart';

class VacunaRepository {
  final String tableName = 'vacuna';
  final DatabaseConnection database = DatabaseConnection();

  // Insertar vacuna
  Future<int> create(VacunaModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // Editar vacuna
  Future<int> edit(VacunaModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'vac_id = ?',
      whereArgs: [data.vacId],
    );
  }

  // Eliminar vacuna
  Future<int> delete(int vacId) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'vac_id = ?', whereArgs: [vacId]);
  }

  // Listar todas las vacunas
  Future<List<VacunaModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => VacunaModel.fromMap(e)).toList();
  }

  // Obtener vacuna por ID
  Future<VacunaModel?> getById(int vacId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'vac_id = ?',
      whereArgs: [vacId],
      limit: 1,
    );

    if (response.isNotEmpty) {
      return VacunaModel.fromMap(response.first);
    }
    return null;
  }

  // Obtener vacunas por Mascota
  Future<List<VacunaModel>> getByMascota(int mascId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'masc_id = ?',
      whereArgs: [mascId],
      orderBy: 'vac_fecha_aplicacion DESC',
    );

    return response.map((e) => VacunaModel.fromMap(e)).toList();
  }
}
