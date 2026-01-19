class VacunaModel {
  int? vacId;
  String vacNombre;
  String vacFechaAplicacion; // YYYY-MM-DD
  String? vacDosis;
  String? vacObservaciones;
  int mascId; // FK → Mascota
  int vetId; // FK → Veterinario

  // Constructor
  VacunaModel({
    this.vacId,
    required this.vacNombre,
    required this.vacFechaAplicacion,
    this.vacDosis,
    this.vacObservaciones,
    required this.mascId,
    required this.vetId,
  });

  // Convertir de Map a Clase (SELECT)
  factory VacunaModel.fromMap(Map<String, dynamic> data) {
    return VacunaModel(
      vacId: data['vac_id'],
      vacNombre: data['vac_nombre'],
      vacFechaAplicacion: data['vac_fecha_aplicacion'],
      vacDosis: data['vac_dosis'],
      vacObservaciones: data['vac_observaciones'],
      mascId: data['masc_id'],
      vetId: data['vet_id'],
    );
  }

  // Convertir de Clase a Map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'vac_id': vacId,
      'vac_nombre': vacNombre,
      'vac_fecha_aplicacion': vacFechaAplicacion,
      'vac_dosis': vacDosis,
      'vac_observaciones': vacObservaciones,
      'masc_id': mascId,
      'vet_id': vetId,
    };
  }
}
