import 'package:flutter/material.dart';

import '../../models/pet_model.dart';
import '../../repositories/pet_repository.dart';

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
  final duenoController = TextEditingController();

  //EDICOON
  MascotaModel? mascota;
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
      //pesoController.text = mascota!.mascPeso;
      pesoController.text = mascota!.mascPeso.toString();
      //duenoController.text = mascota!.dueId;
      duenoController.text = mascota!.dueId.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = mascota != null;
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Mascota")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre de la mascota',
                  hintText: 'Ingrese el nombre de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: especieController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Especie de la mascota',
                  hintText: 'Ingrese la especie de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: sexoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Sexo de la mascota',
                  hintText: 'Ingrese el sexo de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              /*
              TextFormField(
                controller: nacimientoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento de la mascota',
                  hintText: 'Ingrese la fecha de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),*/
              TextFormField(
                controller: nacimientoController,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento de la mascota',
                  hintText: 'Seleccione la fecha',
                  prefixIcon: Icon(Icons.pets),
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () async {
                  DateTime? fechaSeleccionada = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );

                  if (fechaSeleccionada != null) {
                    nacimientoController.text =
                        "${fechaSeleccionada.day.toString().padLeft(2, '0')}/"
                        "${fechaSeleccionada.month.toString().padLeft(2, '0')}/"
                        "${fechaSeleccionada.year}";
                  }
                },
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: colorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Color de la mascota',
                  hintText: 'Ingrese el color de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pesoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Peso de la mascota',
                  hintText: 'Ingrese el peso de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: duenoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Dueño de la mascota',
                  hintText: 'Ingrese el dueño de la mascota',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (formMascota.currentState!.validate()) {
                          //almacenar los datos
                          final repo = MascotaRepository();
                          final mascotaEditar = MascotaModel(
                            mascNombre: nombreController.text,
                            mascEspecie: nombreController.text,
                            mascSexo: sexoController.text,
                            mascFechaNacimiento: nacimientoController.text,
                            mascColor: colorController.text,
                            //mascPeso: pesoController.text,
                            mascPeso: double.parse(pesoController.text),
                            //dueId: duenoController.text,
                            dueId: int.parse(duenoController.text),
                          );
                          //el await se coloca cuando yo llamo a una fucnion asincrona
                          /*edicion*/
                          if (esEditar) {
                            mascotaEditar.mascId = mascota!.mascId;
                            await repo.edit(mascotaEditar);
                          } else {
                            await repo.create(mascotaEditar);
                          }
                          // muestra la interfaz de listado
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Guardar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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
