class com_item{
  int id;
  int idservices;
  String tipo;
  String codigo;
  String nombre;

  com_item(
      {this.id, this.idservices, this.tipo, this.codigo, this.nombre});
  factory com_item.fromMap(Map<String, dynamic> map) {
    return com_item(
      id: map["id"],
      idservices: map["idservices"],
      tipo: map["tipo"],
      codigo: map["codigo"],
      nombre: map["nombre"],
    );
  }

  Map<String, dynamic> toMap() => {
    "idservices": idservices,
    "tipo": tipo,
    "codigo": codigo,
    "nombre": nombre
  };
}