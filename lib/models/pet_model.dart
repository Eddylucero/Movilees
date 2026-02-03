

class MascotaModel {
  int? id;
  String nombre;
  String especie;
  String sexo;
  //String fechaNacimiento;
  String color;
  double peso;
  int dueId;
 // OwnerModel? dueno;

  MascotaModel({
    this.id,
    required this.nombre,
    required this.especie,
    required this.sexo,
    // required this.fechaNacimiento,
    required this.color,
    required this.peso,
    required this.dueId,
   // this.dueno,
  });

  factory MascotaModel.fromMap(Map<String, dynamic> data) {
    return MascotaModel(
      id: data['id'],
      nombre: data['nombre'],
      especie: data['especie'],
      sexo: data['sexo'],
      //fechaNacimiento: data['fecha_nacimiento'],
      color: data['color'],
      peso: (data['peso'] as num).toDouble(),
      dueId: data['due_id'],
      //dueno: data['dueno'] != null ? OwnerModel.fromMap(data['dueno']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'especie': especie,
      'sexo': sexo,
      // 'fecha_nacimiento': fechaNacimiento,
      'color': color,
      'peso': peso,
      'due_id': dueId,
    };
  }
}
