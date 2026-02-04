import 'package:flutter/material.dart';
import 'package:proyecto_final/repositories/vaccine_repository.dart';

import '../../models/pet_model.dart';
import '../../repositories/owner_repository.dart';
import '../../repositories/pet_repository.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final MascotaRepository repo = MascotaRepository();
  final OwnerRepository repoDueno = OwnerRepository();
  final VacunaRepository repoVac = VacunaRepository();

  List<MascotaModel> mascotas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarMascotas();
  }

  Future<void> cargarMascotas() async {
    setState(() => cargando = true);
    mascotas = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarMascota(int mascId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Mascota'),
        content: const Text('¿Está seguro de eliminar esta mascota?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(mascId);
              Navigator.pop(context);
              cargarMascotas();
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Mascotas'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : mascotas.isEmpty
          ? Center(child: Text('No hay mascotas registradas'))
          : ListView.builder(
              itemCount: mascotas.length,
              itemBuilder: (context, i) {
                final pet = mascotas[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text(pet.nombre),
                      subtitle: Text(pet.especie),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/pet/form',
                                arguments: pet,
                              );
                              cargarMascotas();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final totaVacunas = await repoVac
                                  .obtenerTotalVacunasMascota(pet.id!);
                              if (totaVacunas > 0) {
                                mostrarError(
                                  context,
                                  "La mascota tiene vacunas realizadas.Primero elimine las vacunas.",
                                );
                                return;
                              }
                              eliminarMascota(pet.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/pet/form');
          cargarMascotas();
        },
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void mostrarError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Text('Información')]),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
