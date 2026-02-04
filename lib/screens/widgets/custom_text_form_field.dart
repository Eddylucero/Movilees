import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? suffixText;
  final TextInputType keyboardType;
  final int? longitud;
  final int? minlongitud;
  final int? maxlongitud;
  final String hintText;
  final int maxLines;
  final bool requerido;
  final bool numerico;
  final bool decimal;
  final int? maxDecimales;
  final int? maxEnteros;
  final bool letras;
  final bool email;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.longitud,
    this.minlongitud,
    this.maxlongitud,
    required this.hintText,
    this.maxLines = 1,
    this.requerido = false,
    this.numerico = false,
    this.decimal = false,
    this.maxEnteros = 2,
    this.maxDecimales,
    this.letras = false,
    this.email = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: letras
          ? [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
              ),
            ]
          : null,

      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      validator: (v) {
        if (requerido && (v == null || v.trim().isEmpty || v.isEmpty)) {
          return 'El campo $label es requerido';
        }

        if (minlongitud != null && (v == null || v.length < minlongitud!)) {
          return 'Mínimo $minlongitud caracteres.';
        }
        if (maxlongitud != null && (v == null || v.length > maxlongitud!)) {
          return 'Máximo $maxlongitud caracteres.';
        }

        if (numerico && int.tryParse(v!) == null) {
          return 'Debe ingresar un número valido';
        }

        if (decimal && double.tryParse(v!) == null) {
          return 'Debe ingresar un número decimal válido';
        }
        if (decimal && maxDecimales != null) {
          final partes = v!.split('.');
          if (partes.length > 1 && partes[1].length > maxDecimales!) {
            return 'Máximo $maxDecimales decimales permitidos';
          }
        }
        if (decimal && maxEnteros != null) {
          final partes = v!.split('.');
          if (partes[0].length > maxEnteros!) {
            return 'Máximo $maxEnteros dígitos en la parte entera';
          }
        }
        if (longitud != null && v!.length != longitud) {
          return '$label debe tener $longitud dígitos';
        }
        if (email && v != null && v.isNotEmpty) {
          if (!EmailValidator.validate(v)) {
            return 'Ingrese un correo electrónico válido';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Ejm: $hintText',
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixText: suffixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
