import 'package:flutter/material.dart';

import '../../models/veterinarian_model.dart';

import '../../repositories/vaccine_repository.dart';
import '../../repositories/veterinarian_repository.dart';

class VeterinarianScreen extends StatefulWidget {
  const VeterinarianScreen({super.key});

  @override
  State<VeterinarianScreen> createState() => _VeterinarianScreenState();
}

class _VeterinarianScreenState extends State<VeterinarianScreen> {
  final VeterinarioRepository repo = VeterinarioRepository();
  final VacunaRepository repoVac = VacunaRepository();

  List<VeterinarioModel> veterinarios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarVeterinarios();
  }

  Future<void> cargarVeterinarios() async {
    setState(() => cargando = true);
    veterinarios = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarVeterinario(int vetId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Veterinario'),
        content: const Text('¿Está seguro de eliminar este veterinario?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(vetId);
              Navigator.pop(context);
              cargarVeterinarios();
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
        title: const Text('Listado de Veterinarios'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : veterinarios.isEmpty
          ? const Center(child: Text('No hay veterinarios registrados'))
          : ListView.builder(
              itemCount: veterinarios.length,
              itemBuilder: (context, i) {
                final vet = veterinarios[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: Text(vet.vetNombre),
                      subtitle: Text(vet.vetEspecialidad),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/veterinarian/form',
                                arguments: vet,
                              );
                              cargarVeterinarios();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final totalVacunas = await repoVac
                                  .obtenerTotalVacunasVeterinario(vet.vetId!);
                              if (totalVacunas > 0) {
                                mostrarError(
                                  context,
                                  "El veterinario tiene vacunas asociadas. Primero elimine las vacunas.",
                                );
                                return;
                              }
                              eliminarVeterinario(vet.vetId!);
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
          await Navigator.pushNamed(context, '/veterinarian/form');
          cargarVeterinarios();
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
