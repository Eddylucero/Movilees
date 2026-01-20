import 'package:flutter/material.dart';

import '../../models/pet_model.dart';
import '../../repositories/pet_repository.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final MascotaRepository repo = MascotaRepository();

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
        title: const Text('Listado de Mascotas'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : mascotas.isEmpty
          ? const Center(child: Text('No hay mascotas registradas'))
          : ListView.builder(
              itemCount: mascotas.length,
              itemBuilder: (context, i) {
                final pet = mascotas[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text(pet.mascNombre),
                      subtitle: Text(pet.mascEspecie),
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
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminarMascota(pet.mascId!),
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
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
