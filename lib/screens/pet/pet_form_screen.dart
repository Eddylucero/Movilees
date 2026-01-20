import 'package:flutter/material.dart';

import '../../models/pet_model.dart';
import '../../models/owner_model.dart';
import '../../repositories/pet_repository.dart';
import '../../repositories/owner_repository.dart';

class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final formMascota = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final especieController = TextEditingController();
  final sexoController = TextEditingController();
  final nacimientoController = TextEditingController();
  final colorController = TextEditingController();
  final pesoController = TextEditingController();

  final MascotaRepository mascotaRepo = MascotaRepository();
  final OwnerRepository duenoRepo = OwnerRepository();

  MascotaModel? mascota;

  List<OwnerModel> duenos = [];
  int? duenoSeleccionado;
  bool cargandoDuenos = true;

  @override
  void initState() {
    super.initState();
    cargarDuenos();
  }

  Future<void> cargarDuenos() async {
    duenos = await duenoRepo.getAll();
    setState(() => cargandoDuenos = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      mascota = args as MascotaModel;
      nombreController.text = mascota!.mascNombre;
      especieController.text = mascota!.mascEspecie;
      sexoController.text = mascota!.mascSexo;
      nacimientoController.text = mascota!.mascFechaNacimiento;
      colorController.text = mascota!.mascColor;
      pesoController.text = mascota!.mascPeso.toString();
      duenoSeleccionado = mascota!.dueId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = mascota != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Mascota' : 'Nueva Mascota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formMascota,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: especieController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                decoration: InputDecoration(
                  labelText: 'Especie',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: sexoController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                decoration: InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: nacimientoController,
                readOnly: true,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (fecha != null) {
                    nacimientoController.text =
                        '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: colorController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                decoration: InputDecoration(
                  labelText: 'Color',
                  prefixIcon: const Icon(Icons.palette),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: pesoController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso',
                  prefixIcon: const Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              cargandoDuenos
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      value: duenoSeleccionado,
                      items: duenos
                          .map(
                            (d) => DropdownMenuItem<int>(
                              value: d.dueId,
                              child: Text(d.dueNombre),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => duenoSeleccionado = value);
                      },
                      validator: (v) =>
                          v == null ? 'Seleccione un dueño' : null,
                      decoration: InputDecoration(
                        labelText: 'Dueño',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (formMascota.currentState!.validate()) {
                          final data = MascotaModel(
                            mascNombre: nombreController.text,
                            mascEspecie: especieController.text,
                            mascSexo: sexoController.text,
                            mascFechaNacimiento: nacimientoController.text,
                            mascColor: colorController.text,
                            mascPeso: double.parse(pesoController.text),
                            dueId: duenoSeleccionado!,
                          );

                          if (esEditar) {
                            data.mascId = mascota!.mascId;
                            await mascotaRepo.edit(data);
                          } else {
                            await mascotaRepo.create(data);
                          }

                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Guardar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancelar'),
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
