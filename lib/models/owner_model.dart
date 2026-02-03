class OwnerModel {
  int? dueId;
  String dueNombre;
  String dueCedula;
  String dueTelefono;
  String dueDireccion;
  String dueEmail;

  // Constructor
  OwnerModel({
    this.dueId,
    required this.dueNombre,
    required this.dueCedula,
    required this.dueTelefono,
    required this.dueDireccion,
    required this.dueEmail,
  });

  // Convertir de Map a Clase (SELECT)
  factory OwnerModel.fromMap(Map<String, dynamic> data) {
    return OwnerModel(
      dueId: data['due_id'],
      dueNombre: data['due_nombre'],
      dueCedula: data['due_cedula'],
      dueTelefono: data['due_telefono'],
      dueDireccion: data['due_direccion'],
      dueEmail: data['due_email'],
    );
  }

  // Convertir de Clase a Map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'due_id': dueId,
      'due_nombre': dueNombre,
      'due_cedula': dueCedula,
      'due_telefono': dueTelefono,
      'due_direccion': dueDireccion,
      'due_email': dueEmail,
    };
  }
}
