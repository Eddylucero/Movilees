import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._internal();
  factory DatabaseConnection() => instance;

  DatabaseConnection._internal();

  static Database? database;

  Future<Database> get db async {
    if (database != null) return database!;
    database = await _initDb();
    return database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'veterinaria.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) async {
        // ACTIVAR CLAVES FORÁNEAS
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        // DUEÑO
        await db.execute('''
          CREATE TABLE dueno (
            due_id INTEGER PRIMARY KEY AUTOINCREMENT,
            due_nombre TEXT NOT NULL,
            due_cedula TEXT NOT NULL UNIQUE,
            due_telefono TEXT,
            due_direccion TEXT,
            due_email TEXT
          )
        ''');

        // MASCOTA
        await db.execute('''
          CREATE TABLE mascota (
            masc_id INTEGER PRIMARY KEY AUTOINCREMENT,
            masc_nombre TEXT NOT NULL,
            masc_especie TEXT NOT NULL,
            masc_sexo TEXT,
            masc_fecha_nacimiento TEXT,
            masc_color TEXT,
            masc_peso REAL,
            due_id INTEGER NOT NULL,
            FOREIGN KEY (due_id) REFERENCES dueno(due_id)
              ON DELETE CASCADE
              ON UPDATE CASCADE
          )
        ''');

        // VETERINARIO
        await db.execute('''
          CREATE TABLE veterinario (
            vet_id INTEGER PRIMARY KEY AUTOINCREMENT,
            vet_nombre TEXT NOT NULL,
            vet_especialidad TEXT,
            vet_telefono TEXT,
            vet_email TEXT,
            vet_clinica TEXT
          )
        ''');

        // VACUNA
        await db.execute('''
          CREATE TABLE vacuna (
            vac_id INTEGER PRIMARY KEY AUTOINCREMENT,
            vac_nombre TEXT NOT NULL,
            vac_fecha_aplicacion TEXT NOT NULL,
            vac_dosis TEXT,
            vac_observaciones TEXT,
            masc_id INTEGER NOT NULL,
            vet_id INTEGER NOT NULL,
            FOREIGN KEY (masc_id) REFERENCES mascota(masc_id)
              ON DELETE CASCADE
              ON UPDATE CASCADE,
            FOREIGN KEY (vet_id) REFERENCES veterinario(vet_id)
              ON DELETE SET NULL
              ON UPDATE CASCADE
          )
        ''');
      },
    );
  }
}
