import 'package:flutter/material.dart';

import '../../models/vaccine_model.dart';
import '../../models/pet_model.dart';
import '../../models/veterinarian_model.dart';

import '../../repositories/vaccine_repository.dart';
import '../../repositories/pet_repository.dart';
import '../../repositories/veterinarian_repository.dart';
import '../widgets/custom_text_form_field.dart';

class VaccineFormScreen extends StatefulWidget {
  const VaccineFormScreen({super.key});

  @override
  State<VaccineFormScreen> createState() => _VaccineFormScreenState();
}

class _VaccineFormScreenState extends State<VaccineFormScreen> {
  final formVacuna = GlobalKey<FormState>();
  final nombreController = TextEditingController();
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

    if (args != null && vacuna == null) {
      vacuna = args as VacunaModel;
      nombreController.text = vacuna!.vacNombre;
      dosisController.text = vacuna!.vacDosis.toString();
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
        title: Text(esEditar ? 'Editar Vacuna' : 'Registrar Vacuna'),
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
              CustomTextFormField(
                label: 'Vacuna',
                controller: nombreController,
                hintText: 'Moquillo',
                requerido: true,
                icon: Icons.vaccines,
                minlongitud: 5,
                maxlongitud: 20,
              ),

              SizedBox(height: 15),

              DropdownButtonFormField(
                value: mascotaSeleccionada,
                items: mascotas.map((m) {
                  return DropdownMenuItem(value: m.id, child: Text(m.nombre));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    mascotaSeleccionada = value;
                  });
                },
                validator: (v) {
                  if (v == null) {
                    return 'Seleccione una mascota';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              DropdownButtonFormField(
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
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              CustomTextFormField(
                label: 'Dosis',
                controller: dosisController,
                hintText: '1 ml',
                suffixText: 'ml',
                requerido: true,
                keyboardType: TextInputType.number,
                numerico: true,
                icon: Icons.medication,
                maxlongitud: 2,
              ),
              SizedBox(height: 15),

              CustomTextFormField(
                label: 'Observaciones',
                controller: observacionesController,
                hintText: 'Ninguna',
                maxLines: 3,
                icon: Icons.notes,

                maxlongitud: 40,
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
                              //vacFechaAplicacion: fechaController.text,
                              vacDosis: int.parse(dosisController.text),
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
