import 'package:flutter/material.dart';

import '../../models/veterinarian_model.dart';
import '../../repositories/veterinarian_repository.dart';

class VeterinarianFormScreen extends StatefulWidget {
  const VeterinarianFormScreen({super.key});

  @override
  State<VeterinarianFormScreen> createState() => _VeterinarianFormScreenState();
}

class _VeterinarianFormScreenState extends State<VeterinarianFormScreen> {
  final formVet = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final especialidadController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final clinicaController = TextEditingController();

  VeterinarioModel? veterinario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null) {
      veterinario = args as VeterinarioModel;
      nombreController.text = veterinario!.vetNombre;
      especialidadController.text = veterinario!.vetEspecialidad ?? '';
      telefonoController.text = veterinario!.vetTelefono ?? '';
      emailController.text = veterinario!.vetEmail ?? '';
      clinicaController.text = veterinario!.vetClinica ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = veterinario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEditar ? 'Editar Veterinario' : 'Formulario de Veterinario',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formVet,
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
                  hintText: 'Ingrese el nombre del veterinario',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: especialidadController,
                decoration: InputDecoration(
                  labelText: 'Especialidad',
                  hintText: 'Ej: Cirugía, Dermatología',
                  prefixIcon: const Icon(Icons.medical_services_outlined),
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

              SizedBox(height: 15),

              TextFormField(
                controller: clinicaController,
                decoration: InputDecoration(
                  labelText: 'Clínica',
                  hintText: 'Nombre de la clínica',
                  prefixIcon: const Icon(Icons.local_hospital),
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
                          if (formVet.currentState!.validate()) {
                            final repo = VeterinarioRepository();

                            final vet = VeterinarioModel(
                              vetNombre: nombreController.text,
                              vetEspecialidad: especialidadController.text,
                              vetTelefono: telefonoController.text,
                              vetEmail: emailController.text,
                              vetClinica: clinicaController.text,
                            );

                            if (esEditar) {
                              vet.vetId = veterinario!.vetId;
                              await repo.edit(vet);
                            } else {
                              await repo.create(vet);
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

                  SizedBox(width: 10),

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
