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

  Future<bool> cedulaUnica(String cedula) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_cedula = ?',
      whereArgs: [cedula],
    );
    return result.isEmpty;
  }

  Future<bool> celularUnico(String telefono) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_telefono = ?',
      whereArgs: [telefono],
    );
    return result.isEmpty;
  }

  Future<bool> correoUnico(String email) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_email = ?',
      whereArgs: [email],
    );
    return result.isEmpty;
  }

  Future<bool> cedulaUnicaEditar(String cedula, int dueId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_cedula = ? AND due_id != ?',
      whereArgs: [cedula, dueId],
    );
    return result.isEmpty;
  }

  Future<bool> celularUnicoEditar(String telefono, int dueId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_telefono = ? AND due_id != ?',
      whereArgs: [telefono, dueId],
    );
    return result.isEmpty;
  }

  Future<bool> correoUnicoEditar(String email, int dueId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'due_email = ? AND due_id != ?',
      whereArgs: [email, dueId],
    );
    return result.isEmpty;
  }

  Future<int> obtenerTotalMascotasDueno(int dueId) async {
    final db = await database.db;
    final result = await db.query(
      'mascota',
      columns: ['COUNT(*) AS total'],
      where: 'due_id = ?',
      whereArgs: [dueId],
    );
    return result.first['total'] as int;
  }
}
