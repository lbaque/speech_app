class config_parametro {
  int id;
  int idservices;
  String tipo;
  String codigo;
  String valor;

  config_parametro(
      {this.id, this.idservices, this.tipo, this.codigo, this.valor});
  factory config_parametro.fromMap(Map<String, dynamic> map) {
    return config_parametro(
      id: map["id"],
      idservices: map["idservices"],
      tipo: map["tipo"],
      codigo: map["codigo"],
      valor: map["valor"],
    );
  }

  Map<String, dynamic> toMap() => {
        "idservices": idservices,
        "tipo": tipo,
        "codigo": codigo,
        "valor": valor
      };
}
