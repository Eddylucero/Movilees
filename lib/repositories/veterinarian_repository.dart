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

  Future<bool> cedulaUnica(String cedula) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_cedula = ?',
      whereArgs: [cedula],
    );
    return result.isEmpty;
  }

  Future<bool> celularUnico(String telefono) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_telefono = ?',
      whereArgs: [telefono],
    );
    return result.isEmpty;
  }

  Future<bool> correoUnico(String email) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_email = ?',
      whereArgs: [email],
    );
    return result.isEmpty;
  }

  Future<bool> cedulaUnicaEditar(String cedula, int vetId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_cedula = ? AND vet_id != ?',
      whereArgs: [cedula, vetId],
    );
    return result.isEmpty;
  }

  Future<bool> celularUnicoEditar(String telefono, int vetId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_telefono = ? AND vet_id != ?',
      whereArgs: [telefono, vetId],
    );
    return result.isEmpty;
  }

  Future<bool> correoUnicoEditar(String email, int vetId) async {
    final db = await database.db;
    final result = await db.query(
      tableName,
      where: 'vet_email = ? AND vet_id != ?',
      whereArgs: [email, vetId],
    );
    return result.isEmpty;
  }

  
}
