import 'package:flutter/material.dart';

import '../../models/vaccine_model.dart';
import '../../repositories/vaccine_repository.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  final VacunaRepository repo = VacunaRepository();

  List<VacunaModel> vacunas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarVacunas();
  }

  Future<void> cargarVacunas() async {
    setState(() => cargando = true);
    vacunas = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarVacuna(int vacId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Vacuna'),
        content: const Text('¿Está seguro de eliminar esta vacuna?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(vacId);
              Navigator.pop(context);
              cargarVacunas();
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
        title: Text('Listado de Vacunas'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : vacunas.isEmpty
          ? Center(child: Text('No hay vacunas registradas'))
          : ListView.builder(
              itemCount: vacunas.length,
              itemBuilder: (context, i) {
                final vac = vacunas[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.vaccines),
                      title: Text(vac.vacNombre),
                      subtitle: Text('Dosis: ${vac.vacDosis}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/vaccine/form',
                                arguments: vac,
                              );
                              cargarVacunas();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminarVacuna(vac.vacId!),
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
          await Navigator.pushNamed(context, '/vaccine/form');
          cargarVacunas();
        },
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
