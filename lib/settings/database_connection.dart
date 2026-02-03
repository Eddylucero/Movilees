import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._internal();
  factory DatabaseConnection() => instance;

  DatabaseConnection._internal();

  static Database? database;

  Future<Database> get db async {
    if (database != null) return database!;
    database = await inicializarDb();
    return database!;
  }

  Future<Database> inicializarDb() async {
    final rutaDb = await getDatabasesPath();
    final rutaFinal = join(rutaDb, 'veterinaria.db');

    return await openDatabase(
      rutaFinal,
      version: 1,
      // AQUI SE ACTIVAN CLAVES FORÁNEAS
      onConfigure: (Database db) async {
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
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            especie TEXT NOT NULL,
            sexo TEXT NOT NULL,  
            color TEXT NOT NULL,
            peso REAL NOT NULL,
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
            vet_especialidad TEXT NOT NULL,
            vet_telefono TEXT NOT NULL,
            vet_email TEXT NOT NULL,
            vet_clinica TEXT
          )
        ''');

        // VACUNA
        await db.execute('''
          CREATE TABLE vacuna (
            vac_id INTEGER PRIMARY KEY AUTOINCREMENT,
            vac_nombre TEXT NOT NULL,
            vac_dosis INTEGER NOT NULL,
            vac_observaciones TEXT,
            masc_id INTEGER NOT NULL,
            vet_id INTEGER NOT NULL,
            FOREIGN KEY (masc_id) REFERENCES mascota(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE,
            FOREIGN KEY (vet_id) REFERENCES veterinario(vet_id)
              ON DELETE CASCADE           
              ON UPDATE CASCADE
          )
        ''');
      },
    );
  }
}
