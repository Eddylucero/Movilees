import 'package:flutter/material.dart';

import '../../models/veterinarian_model.dart';
import '../../repositories/veterinarian_repository.dart';
import '../widgets/custom_text_form_field.dart';

class VeterinarianFormScreen extends StatefulWidget {
  const VeterinarianFormScreen({super.key});

  @override
  State<VeterinarianFormScreen> createState() => _VeterinarianFormScreenState();
}

class _VeterinarianFormScreenState extends State<VeterinarianFormScreen> {
  final formVet = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  //final especialidadController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final clinicaController = TextEditingController();

  VeterinarioModel? veterinarioGlobal;

  //aqui defino la lista de especialidades
  List<Map<String, dynamic>> especialidades = [
    {'especialidad': 'Medicina Interna'},
    {'especialidad': 'Cirugía'},
    {'especialidad': 'Oncología'},
    {'especialidad': 'Cardiología'},
    {'especialidad': 'Oftalmología'},
  ];
  String? especialidadSeleccionada;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && veterinarioGlobal == null) {
      veterinarioGlobal = args as VeterinarioModel;
      nombreController.text = veterinarioGlobal!.vetNombre;
      especialidadSeleccionada = veterinarioGlobal!.vetEspecialidad;
      //especialidadController.text = veterinarioGlobal!.vetEspecialidad ?? '';
      telefonoController.text = veterinarioGlobal!.vetTelefono;
      emailController.text = veterinarioGlobal!.vetEmail;
      clinicaController.text = veterinarioGlobal!.vetClinica;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = veterinarioGlobal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Veterinario' : 'Registrar Veterinario'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formVet,
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(height: 15),

                  CustomTextFormField(
                    label: 'Nombre Completo',
                    controller: nombreController,
                    icon: Icons.person,
                    keyboardType: TextInputType.text,
                    hintText: 'Juan Gonzáles',
                    requerido: true,
                    minlongitud: 5,
                    maxlongitud: 40,
                    letras: true,
                  ),

                  SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: especialidadSeleccionada,
                    items: especialidades.map((d) {
                      return DropdownMenuItem<String>(
                        value: d['especialidad'],
                        child: Text(d['especialidad']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        especialidadSeleccionada = value;
                      });
                    },
                    validator: (v) =>
                        v == null ? 'Seleccione la especialidad' : null,
                    decoration: InputDecoration(
                      labelText: 'Especialidad',
                      prefixIcon: Icon(Icons.medical_information),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  CustomTextFormField(
                    label: 'Teléfono',
                    controller: telefonoController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.number,
                    longitud: 10,
                    hintText: '0969587458',
                    requerido: true,
                  ),

                  SizedBox(height: 15),

                  CustomTextFormField(
                    label: 'Email',
                    controller: emailController,
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'correo@gmail.com',
                    requerido: true,
                    minlongitud: 5,
                    maxlongitud: 40,
                  ),

                  SizedBox(height: 15),

                  CustomTextFormField(
                    label: 'Clínica',
                    controller: clinicaController,
                    hintText: 'SeguriVet',
                    minlongitud: 5,
                    maxlongitud: 40,
                    icon: Icons.local_hospital,
                    requerido: true,
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
                                  vetEspecialidad: especialidadSeleccionada!,
                                  vetTelefono: telefonoController.text,
                                  vetEmail: emailController.text,
                                  vetClinica: clinicaController.text,
                                );

                                if (esEditar) {
                                  vet.vetId = veterinarioGlobal!.vetId;
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
            ],
          ),
        ),
      ),
    );
  }
}
