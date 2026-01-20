import 'package:flutter/material.dart';

import '../../models/vaccine_model.dart';
import '../../models/pet_model.dart';
import '../../models/veterinarian_model.dart';

import '../../repositories/vaccine_repository.dart';
import '../../repositories/pet_repository.dart';
import '../../repositories/veterinarian_repository.dart';

class VaccineFormScreen extends StatefulWidget {
  const VaccineFormScreen({super.key});

  @override
  State<VaccineFormScreen> createState() => _VaccineFormScreenState();
}

class _VaccineFormScreenState extends State<VaccineFormScreen> {
  final formVacuna = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final dosisController = TextEditingController();
  final observacionesController = TextEditingController();

  int? mascotaSeleccionada;
  int? veterinarioSeleccionado;

  List<MascotaModel> mascotas = [];
  List<VeterinarioModel> veterinarios = [];

  VacunaModel? vacuna;

  @override
  void initState() {
    super.initState();
    cargarCombos();
  }

  Future<void> cargarCombos() async {
    final petRepo = MascotaRepository();
    final vetRepo = VeterinarioRepository();

    mascotas = await petRepo.getAll();
    veterinarios = await vetRepo.getAll();

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null) {
      vacuna = args as VacunaModel;
      nombreController.text = vacuna!.vacNombre;
      fechaController.text = vacuna!.vacFechaAplicacion;
      dosisController.text = vacuna!.vacDosis ?? '';
      observacionesController.text = vacuna!.vacObservaciones ?? '';
      mascotaSeleccionada = vacuna!.mascId;
      veterinarioSeleccionado = vacuna!.vetId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = vacuna != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Vacuna' : 'Formulario de Vacuna'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formVacuna,
          child: ListView(
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
                  labelText: 'Vacuna',
                  prefixIcon: const Icon(Icons.vaccines),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: fechaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha aplicación',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: const Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              DropdownButtonFormField<int>(
                value: mascotaSeleccionada,
                items: mascotas.map((m) {
                  return DropdownMenuItem(
                    value: m.mascId,
                    child: Text(m.mascNombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    mascotaSeleccionada = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una mascota' : null,
                decoration: InputDecoration(
                  labelText: 'Mascota',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              DropdownButtonFormField<int>(
                value: veterinarioSeleccionado,
                items: veterinarios.map((v) {
                  return DropdownMenuItem(
                    value: v.vetId,
                    child: Text(v.vetNombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    veterinarioSeleccionado = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un veterinario' : null,
                decoration: InputDecoration(
                  labelText: 'Veterinario',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: dosisController,
                decoration: InputDecoration(
                  labelText: 'Dosis',
                  prefixIcon: const Icon(Icons.medication),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: observacionesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  prefixIcon: const Icon(Icons.notes),
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
                          if (formVacuna.currentState!.validate()) {
                            final repo = VacunaRepository();

                            final data = VacunaModel(
                              vacNombre: nombreController.text,
                              vacFechaAplicacion: fechaController.text,
                              vacDosis: dosisController.text,
                              vacObservaciones: observacionesController.text,
                              mascId: mascotaSeleccionada!,
                              vetId: veterinarioSeleccionado!,
                            );

                            if (esEditar) {
                              data.vacId = vacuna!.vacId;
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
