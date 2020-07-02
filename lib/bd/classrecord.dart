class classrecord {
  int id;
  String nombre;
  int puntos;
  int nivel;

  classrecord ({this.id, this.nombre, this.puntos, this.nivel});

  Map <String, dynamic> toMap() => {
    "id" : id,
    "nombre" : nombre,
    "puntos" : puntos,
    "nivel" : nivel,
  };

  factory classrecord.fromMap (Map<String, dynamic> json) => new classrecord (
    id: json ["id"],
    nombre: json["nombre"],
    puntos: json["puntos"],
    nivel: json["nivel"]
  );
}