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

  Future<void> eliminarOwner(int dueId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Dueño'),
        content: Text('¿Está seguro de eliminar este dueño?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(dueId);
              Navigator.pop(context);
              cargarOwners();
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Dueños'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : owners.isEmpty
          ? Center(child: Text('No hay dueños registrados.'))
          : ListView.builder(
              itemCount: owners.length,
              itemBuilder: (context, i) {
                final owner = owners[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(owner.dueNombre),
                      subtitle: Text(owner.dueCedula),
                      trailing: Row(
                        //para agregar objetos dentro del card
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
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
                            icon: Icon(Icons.delete, color: Colors.red),
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
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
