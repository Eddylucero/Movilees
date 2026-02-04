class VeterinarioModel {
  int? vetId;
  String vetNombre;
  String vetCedula;
  String vetEspecialidad;
  String vetTelefono;
  String vetEmail;
  String vetClinica;

  // Constructor
  VeterinarioModel({
    this.vetId,
    required this.vetNombre,
    required this.vetCedula,
    required this.vetEspecialidad,
    required this.vetTelefono,
    required this.vetEmail,
    required this.vetClinica,
  });

  factory VeterinarioModel.fromMap(Map<String, dynamic> data) {
    return VeterinarioModel(
      vetId: data['vet_id'],
      vetNombre: data['vet_nombre'],
      vetCedula: data['vet_cedula'],
      vetEspecialidad: data['vet_especialidad'],
      vetTelefono: data['vet_telefono'],
      vetEmail: data['vet_email'],
      vetClinica: data['vet_clinica'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vet_id': vetId,
      'vet_nombre': vetNombre,
      'vet_cedula': vetCedula,
      'vet_especialidad': vetEspecialidad,
      'vet_telefono': vetTelefono,
      'vet_email': vetEmail,
      'vet_clinica': vetClinica,
    };
  }
}
