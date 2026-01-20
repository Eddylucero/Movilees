import 'package:flutter/material.dart';

import '../../models/owner_model.dart';
import '../../repositories/owner_repository.dart';

class OwnerFormScreen extends StatefulWidget {
  const OwnerFormScreen({super.key});

  @override
  State<OwnerFormScreen> createState() => _OwnerFormScreenState();
}

class _OwnerFormScreenState extends State<OwnerFormScreen> {
  final formOwner = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final emailController = TextEditingController();

  OwnerModel? owner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null) {
      owner = args as OwnerModel;
      nombreController.text = owner!.dueNombre;
      cedulaController.text = owner!.dueCedula;
      telefonoController.text = owner!.dueTelefono ?? '';
      direccionController.text = owner!.dueDireccion ?? '';
      emailController.text = owner!.dueEmail ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = owner != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Dueño' : 'Formulario de Dueño'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formOwner,
          child: Column(
            children: [
              SizedBox(height: 15),

              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre del dueño',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: cedulaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La cédula es requerida';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Ingrese la cédula',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ingrese el teléfono',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingrese la dirección',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'correo@ejemplo.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (formOwner.currentState!.validate()) {
                            final repo = OwnerRepository();

                            final data = OwnerModel(
                              dueNombre: nombreController.text,
                              dueCedula: cedulaController.text,
                              dueTelefono: telefonoController.text,
                              dueDireccion: direccionController.text,
                              dueEmail: emailController.text,
                            );

                            if (esEditar) {
                              data.dueId = owner!.dueId;
                              await repo.edit(data);
                            } else {
                              await repo.create(data);
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
