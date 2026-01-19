class MascotaModel {
  int? mascId;
  String mascNombre;
  String mascEspecie;
  String? mascSexo;
  String? mascFechaNacimiento; // YYYY-MM-DD
  String? mascColor;
  double? mascPeso;
  int dueId; // FK → Dueño

  // Constructor
  MascotaModel({
    this.mascId,
    required this.mascNombre,
    required this.mascEspecie,
    this.mascSexo,
    this.mascFechaNacimiento,
    this.mascColor,
    this.mascPeso,
    required this.dueId,
  });

  // Convertir de Map a Clase (SELECT)
  factory MascotaModel.fromMap(Map<String, dynamic> data) {
    return MascotaModel(
      mascId: data['masc_id'],
      mascNombre: data['masc_nombre'],
      mascEspecie: data['masc_especie'],
      mascSexo: data['masc_sexo'],
      mascFechaNacimiento: data['masc_fecha_nacimiento'],
      mascColor: data['masc_color'],
      mascPeso: data['masc_peso'] != null
          ? (data['masc_peso'] as num).toDouble()
          : null,
      dueId: data['due_id'],
    );
  }

  // Convertir de Clase a Map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'masc_id': mascId,
      'masc_nombre': mascNombre,
      'masc_especie': mascEspecie,
      'masc_sexo': mascSexo,
      'masc_fecha_nacimiento': mascFechaNacimiento,
      'masc_color': mascColor,
      'masc_peso': mascPeso,
      'due_id': dueId,
    };
  }
}
