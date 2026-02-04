import 'package:flutter/material.dart';

import '../../models/owner_model.dart';
import '../../repositories/owner_repository.dart';
import '../widgets/custom_text_form_field.dart';

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
      telefonoController.text = owner!.dueTelefono;
      direccionController.text = owner!.dueDireccion;
      emailController.text = owner!.dueEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = owner != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Dueño' : 'Registrar Dueño'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formOwner,
          child: ListView(
            padding: const EdgeInsets.all(16),
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

                  CustomTextFormField(
                    label: 'Cédula',
                    controller: cedulaController,
                    icon: Icons.card_membership_outlined,
                    keyboardType: TextInputType.number,
                    longitud: 10,
                    hintText: '0999999999',
                    requerido: true,
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
                    label: 'Dirección Domiciliaria',
                    controller: direccionController,
                    icon: Icons.home,
                    hintText: 'Quito',
                    requerido: true,
                    minlongitud: 5,
                    maxlongitud: 40,
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
                    email: true,
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
                              if (!formOwner.currentState!.validate()) return;

                              final repo = OwnerRepository();

                              final data = OwnerModel(
                                dueNombre: nombreController.text,
                                dueCedula: cedulaController.text,
                                dueTelefono: telefonoController.text,
                                dueDireccion: direccionController.text,
                                dueEmail: emailController.text,
                              );

                              if (esEditar) {
                                final cedulaUnica = await repo
                                    .cedulaUnicaEditar(
                                      cedulaController.text,
                                      owner!.dueId!,
                                    );

                                final celularUnico = await repo
                                    .celularUnicoEditar(
                                      telefonoController.text,
                                      owner!.dueId!,
                                    );

                                final correoUnico = await repo
                                    .correoUnicoEditar(
                                      emailController.text,
                                      owner!.dueId!,
                                    );

                                if (!cedulaUnica) {
                                  mostrarError(
                                    context,
                                    'Ya existe un dueño con esta cédula',
                                  );
                                  return;
                                }

                                if (!celularUnico) {
                                  mostrarError(
                                    context,
                                    "Ya existe un dueño con este número celular ",
                                  );
                                  return;
                                }

                                if (!correoUnico) {
                                  mostrarError(
                                    context,
                                    "Ya existe un dueño con este correo",
                                  );
                                }

                                data.dueId = owner!.dueId;
                                await repo.edit(data);
                              } else {
                                final cedulaUnica = await repo.cedulaUnica(
                                  cedulaController.text,
                                );
                                final celularUnico = await repo.celularUnico(
                                  telefonoController.text,
                                );
                                final correoUnico = await repo.correoUnico(
                                  emailController.text,
                                );
                                if (!cedulaUnica) {
                                  mostrarError(
                                    context,
                                    'Ya existe un dueño con esta cédula',
                                  );
                                  return;
                                }

                                if (!celularUnico) {
                                  mostrarError(
                                    context,
                                    'Ya existe un dueño con este celular',
                                  );
                                  return;
                                }

                                if (!correoUnico) {
                                  mostrarError(
                                    context,
                                    'Ya existe un dueño con este correo',
                                  );
                                  return;
                                }
                                await repo.create(data);
                              }

                              Navigator.pop(context);
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
