import 'package:flutter/material.dart';

import '../../models/pet_model.dart';
import '../../models/owner_model.dart';
import '../../repositories/pet_repository.dart';
import '../../repositories/owner_repository.dart';
import '../widgets/custom_text_form_field.dart';

class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final formMascota = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final pesoController = TextEditingController();
  MascotaModel? mascotaGlobal;
  List<OwnerModel> duenos = [];
  int? duenoSeleccionado;

  //aqui defino la lista de especies
  List<Map<String, dynamic>> especies = [
    {'especie': 'Canino'},
    {'especie': 'Felino'},
  ];
  String? especieSeleccionada;

  //aqui defino la lista de sexo
  List<Map<String, dynamic>> sexos = [
    {'sexo': 'Macho'},
    {'sexo': 'Hembra'},
  ];
  String? sexoSeleccionado;

  //aqui defino la lista de colores
  List<Map<String, dynamic>> colores = [
    {'color': 'Blanco'},
    {'color': 'Negro'},
    {'color': 'Café'},
    {'color': 'Blaco/Negro'},
    {'color': 'Blanco/Café'},
    {'color': 'Gris'},
    {'color': 'Naranja'},
  ];
  String? colorSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarDuenos();
  }

  Future<void> cargarDuenos() async {
    var duenoRepo = OwnerRepository();
    duenos = await duenoRepo.getAll();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && mascotaGlobal == null) {
      mascotaGlobal = args as MascotaModel;
      nombreController.text = mascotaGlobal!.nombre;
      especieSeleccionada = mascotaGlobal!.especie;
      sexoSeleccionado = mascotaGlobal!.sexo;
      colorSeleccionado = mascotaGlobal!.color;
      pesoController.text = mascotaGlobal!.peso.toString();
      duenoSeleccionado = mascotaGlobal!.dueId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = mascotaGlobal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Mascota' : 'Registrar Mascota'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formMascota,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                children: [
                  SizedBox(height: 10),

                  CustomTextFormField(
                    label: 'Nombre',
                    controller: nombreController,
                    hintText: 'Peluchin',
                    icon: Icons.pets,
                    requerido: true,
                    letras: true,
                    minlongitud: 4,
                    maxlongitud: 20,
                  ),

                  SizedBox(height: 30),

                  DropdownButtonFormField<String>(
                    value: especieSeleccionada,
                    items: especies.map((d) {
                      return DropdownMenuItem<String>(
                        value: d['especie'],
                        child: Text(d['especie']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        especieSeleccionada = value;
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Seleccione una especie';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Especie',
                      prefixIcon: const Icon(Icons.pets),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  DropdownButtonFormField<String>(
                    value: sexoSeleccionado,
                    items: sexos.map((d) {
                      return DropdownMenuItem<String>(
                        value: d['sexo'],
                        child: Text(d['sexo']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sexoSeleccionado = value;
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Seleccione el sexo';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Sexo',
                      prefixIcon: Icon(Icons.pets),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: colorSeleccionado,
                    items: colores.map((d) {
                      return DropdownMenuItem<String>(
                        value: d['color'],
                        child: Text(d['color']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        colorSeleccionado = value;
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Seleccione el color';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Color',
                      prefixIcon: Icon(Icons.invert_colors_sharp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  CustomTextFormField(
                    label: 'Peso',
                    controller: pesoController,
                    hintText: '4kg',
                    icon: Icons.monitor_weight,
                    decimal: true,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    suffixText: 'kg',
                    maxDecimales: 2,
                  ),

                  SizedBox(height: 30),

                  DropdownButtonFormField<int>(
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
                      setState(() {
                        duenoSeleccionado = value;
                      });
                    },
                    validator: (v) {
                      if (v == null) {
                        return 'Seleccione un dueño';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Dueño',
                      prefixIcon: const Icon(Icons.person),
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
                              if (formMascota.currentState!.validate()) {
                                final repo = MascotaRepository();
                                final data = MascotaModel(
                                  nombre: nombreController.text,
                                  especie: especieSeleccionada!,
                                  sexo: sexoSeleccionado!,

                                  color: colorSeleccionado!,
                                  peso: double.parse(pesoController.text),
                                  dueId: duenoSeleccionado!,
                                );

                                if (esEditar) {
                                  final nombreUnico = await repo
                                      .nombreUnicoEditar(
                                        nombreController.text,
                                        duenoSeleccionado!,
                                        mascotaGlobal!.id!,
                                      );

                                  if (!nombreUnico) {
                                    mostrarError(
                                      context,
                                      "Ya existe el nombre de la mascota con ese dueño",
                                    );

                                    return;
                                  }
                                  data.dueId = duenoSeleccionado!;
                                  data.id = mascotaGlobal!.id;
                                  await repo.edit(data);
                                } else {
                                  final nombreUnico = await repo.nombreUnico(
                                    nombreController.text,
                                    duenoSeleccionado!,
                                  );
                                  if (!nombreUnico) {
                                    mostrarError(
                                      context,
                                      "El dueño ya tiene registrada una mascota con ese nombre.",
                                    );
                                    return;
                                  }
                                  await repo.create(data);
                                }
                                Navigator.pop(context);
                              }
                            },

                            child: Text(esEditar ? 'Actualizar' : 'Guardar'),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
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
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
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

  void mostrarError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Text('Información')]),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
