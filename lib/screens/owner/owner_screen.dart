import 'package:flutter/material.dart';

import '../../models/owner_model.dart';
import '../../repositories/owner_repository.dart';

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  final OwnerRepository repo = OwnerRepository();

  List<OwnerModel> owners = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarOwners();
  }

  Future<void> cargarOwners() async {
    setState(() => cargando = true);
    owners = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarOwner(int dueId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Dueño'),
        content: const Text('¿Está seguro de eliminar este dueño?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(dueId);
              Navigator.pop(context);
              cargarOwners();
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
        title: const Text('Listado de Dueños'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : owners.isEmpty
          ? const Center(child: Text('No hay dueños registrados'))
          : ListView.builder(
              itemCount: owners.length,
              itemBuilder: (context, i) {
                final owner = owners[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(owner.dueNombre),
                      subtitle: Text(owner.dueCedula),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/owner/form',
                                arguments: owner,
                              );
                              cargarOwners();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminarOwner(owner.dueId!),
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
          await Navigator.pushNamed(context, '/owner/form');
          cargarOwners();
        },
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
