class VeterinarioModel {
  int? vetId;
  String vetNombre;
  String vetEspecialidad;
  String vetTelefono;
  String vetEmail;
  String vetClinica;

  // Constructor
  VeterinarioModel({
    this.vetId,
    required this.vetNombre,
    required this.vetEspecialidad,
    required this.vetTelefono,
    required this.vetEmail,
    required this.vetClinica,
  });

  // Convertir de Map a Clase (SELECT)
  factory VeterinarioModel.fromMap(Map<String, dynamic> data) {
    return VeterinarioModel(
      vetId: data['vet_id'],
      vetNombre: data['vet_nombre'],
      vetEspecialidad: data['vet_especialidad'],
      vetTelefono: data['vet_telefono'],
      vetEmail: data['vet_email'],
      vetClinica: data['vet_clinica'],
    );
  }

  // Convertir de Clase a Map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'vet_id': vetId,
      'vet_nombre': vetNombre,
      'vet_especialidad': vetEspecialidad,
      'vet_telefono': vetTelefono,
      'vet_email': vetEmail,
      'vet_clinica': vetClinica,
    };
  }
}
